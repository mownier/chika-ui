//
//  SelectedContactCarousel.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/16/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class SelectedContactCarousel: UICollectionViewController {
    
    var itemAt: ((Int) -> SelectedContactCarouselCellItem)!
    var itemSize: (() -> CGSize)!
    var itemCount: (() -> Int)!
    var cellTheme: (() -> SelectedContactCarouselCellTheme)!
    var onRemoveItemAt: ((Int) -> Bool)!
    var placeholderCellText: (() -> String)!
    var isPlaceholderCellShown: Bool = true
    
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
    }
    
    public var itemWidth: CGFloat {
        return itemSize?().width ?? 0
    }
    
    public var itemHeight: CGFloat {
        return itemSize?().height ?? 0
    }
    
    deinit {
        dispose()
    }
    
    public convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.sectionInsetReference = .fromSafeArea
        layout.minimumInteritemSpacing = 1
        self.init(collectionViewLayout: layout)
    }
    
    public override func loadView() {
        super.loadView()
        
        flowLayout?.itemSize = itemSize?() ?? CGSize(width: 100, height: 128)
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceHorizontal = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.contentInsetAdjustmentBehavior = .always
        
        collectionView?.register(SelectedContactCarouselCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView?.register(SelectedContactCarouselCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.reloadData()
    }

    public override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemCount?() ?? 0
        
        case 1:
            return isPlaceholderCellShown ? 1 : 0
        
        default:
            return 0
        }
    }

    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SelectedContactCarouselCell
            let item = itemAt?(indexPath.row)
            cell.applyTheme(cellTheme?())
            cell.layout(withItem: item)
            cell.onRemove = onRemove
            
            return cell
        
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath) as! SelectedContactCarouselCell
            cell.applyTheme(cellTheme?())
            cell.layout(withPlaceholderText: placeholderCellText?())
            
            return cell
        
        default:
            return UICollectionViewCell()
        }
    }
    
    public func dispose() {
        itemAt = nil
        itemSize = nil
        itemCount = nil
        cellTheme = nil
        onRemoveItemAt = nil
        placeholderCellText = nil
    }
    
    @discardableResult
    public func removeItem(at index: Int) -> Bool {
        return remove(at: index, in: 0)
    }
    
    @discardableResult
    public func insertItem(at index: Int) -> Bool {
        return insert(at: index, in: 0)
    }
    
    @discardableResult
    public func insertItemAtFirst() -> Bool {
        return insertItem(at: 0)
    }
    
    @discardableResult
    public func insertItemAtLast() -> Bool {
        guard let count = itemCount?() else {
            return false
        }
        
        return insertItem(at: count - 1)
    }
    
    @discardableResult
    func insertPlaceholderCell() -> Bool {
        return insert(at: 0, in: 1)
    }
    
    @discardableResult
    func removePlaceholderCell() -> Bool {
        return remove(at: 0, in: 1)
    }
    
    @discardableResult
    func insert(at index: Int, in section: Int) -> Bool {
        guard let sectionCount = collectionView?.numberOfSections, section >= 0, section < sectionCount,
            let itemCount = collectionView?.numberOfItems(inSection: section), (index >= 0 && index < itemCount) || (index == 0 && itemCount == 0) else {
                return false
        }

        let indexPaths = [IndexPath(row: index, section: section)]
        
        collectionView?.performBatchUpdates({
            collectionView?.insertItems(at: indexPaths)
            
        }) { [weak self] _ in
            if section == 0 {
                self?.isPlaceholderCellShown = false
                self?.removePlaceholderCell()
            }
        }
        
        return true
    }
    
    @discardableResult
    func remove(at index: Int, in section: Int) -> Bool {
        guard let sectionCount = collectionView?.numberOfSections, section >= 0, section < sectionCount,
            let itemCount = collectionView?.numberOfItems(inSection: section), index >= 0, index < itemCount else {
                return false
        }
        
        let indexPaths = [IndexPath(row: index, section: section)]
        
        collectionView?.performBatchUpdates({
            collectionView?.deleteItems(at: indexPaths)
            
        }) { [weak self] done in
            guard done, section == 0, itemCount == 1 else {
                return
            }
            
            self?.isPlaceholderCellShown = true
            self?.insertPlaceholderCell()
        }
        
        return true
    }
    
    func onRemove(_ cell: SelectedContactCarouselCell) {
        guard let indexPath = collectionView?.indexPath(for: cell), indexPath.section == 0 else {
            return
        }
        
        guard let isOK = onRemoveItemAt?(indexPath.row), isOK else {
            return
        }
        
        remove(at: indexPath.row, in: indexPath.section)
    }

}
