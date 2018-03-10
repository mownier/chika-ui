//
//  PhotoLibraryViewController.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/2/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import Photos

public class PhotoLibraryViewController: UIViewController {

    var flowLayout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!
    
    var data: [PHAsset] = [] {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            collectionView.reloadData()
        }
    }
    
    var columns: CGFloat = 3
    var itemSpacing: CGFloat = 8
    
    var imageFetcherOptions: ((PHAsset) -> PHImageRequestOptions)?
    var imageAssetFetcherOptions: (() -> PHFetchOptions)?
    
    var imageFetcher: ((PHAsset, PHImageRequestOptions?, CGSize) -> PhotoLibraryImageFetcher)!
    var imageAssetFetcher: ((PHFetchOptions?) -> PhotoLibrayImageAssetFetcher)!
    
    var imageFetcherOperation: PhotoLibraryImageFetcherOperation<PHAsset> = PhotoLibraryImageFetcherOperation<PHAsset>()
    
    var currentImageFetcher: PhotoLibrayImageAssetFetcher?
    
    var onSelectPhoto: ((PHAsset) -> Void)?
    var onDeselectPhoto: ((PHAsset) -> Void)?
    
    var selectedIndexes: [Int: Bool] = [:]
    
    var headerView: UIView? {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            guard headerView == nil else {
                view.setNeedsLayout()
                view.layoutIfNeeded()
                return
            }
            
            oldValue?.removeFromSuperview()
            collectionView.contentInset.top = 0
        }
    }
    
    public var selectionStyle: SelectionStyle = .multiple {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            selectedIndexes.forEach { item in
                deselectIndex(item.key)
            }
        }
    }
    
    public var selections: [PHAsset] {
        return selectedIndexes.flatMap({
            $0.key
            
        }).map({
            guard $0 >= 0, $0 < data.count else {
                return nil
            }
            
            return data[$0]
            
        }).flatMap({
            $0
        })
    }
    
    public override func loadView() {
        super.loadView()
        
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = itemSpacing
        flowLayout.minimumInteritemSpacing = itemSpacing
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        
        collectionView.register(PhotoLibraryCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        view.addSubview(collectionView)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let options = imageAssetFetcherOptions?()
        let fetcher = imageAssetFetcher(options)
        fetcher.onImageAssetsChanged({ [weak self] assets in
            self?.completion(assets)
            
        }).fetchImageAssets(withCompletion: completion)
        
        currentImageFetcher = fetcher
    }
    
    public override func viewDidLayoutSubviews() {
        collectionView.frame = view.bounds
        
        flowLayout.itemSize.width = (collectionView.bounds.width - flowLayout.minimumInteritemSpacing * (columns - 1) - collectionView.contentInset.left - collectionView.contentInset.right) / columns
        flowLayout.itemSize.height = flowLayout.itemSize.width
        
        guard headerView != nil else {
            return
        }
        
        var rect = CGRect.zero
        rect.size.width = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right
        rect.size.height =  headerView!.frame.height
        rect.origin.y = -(rect.height + flowLayout.minimumInteritemSpacing)
        headerView!.frame = rect
        
        collectionView.contentInset.top = (rect.height + flowLayout.minimumInteritemSpacing)
        
        if !collectionView.subviews.contains(headerView!) {
            collectionView.addSubview(headerView!)
        }
    }
    
    public func reloadData() {
        collectionView?.reloadData()
    }
    
    public func setHeaderView(_ view: UIView?) {
        headerView = view
    }

    func completion(_ assets: [PHAsset]) {
        let sorted = assets.flatMap({ $0.creationDate == nil ? nil : $0 }).sorted(by: { asset1, asset2 -> Bool in
            return asset1.creationDate!.timeIntervalSince1970 > asset2.creationDate!.timeIntervalSince1970
        })
        
        let indexes: [Int] = selections.flatMap { asset -> Int? in
            return sorted.index(where: { $0.localIdentifier == asset.localIdentifier })
        }
        
        selectedIndexes.removeAll()
        indexes.forEach({ selectedIndexes[$0] = true })
        
        data = sorted
    }
    
    public enum SelectionStyle {
        
        case single, multiple
    }
    
}

extension PhotoLibraryViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoLibraryCollectionViewCell
        
        cell.isSelected(selectedIndexes[indexPath.row] != nil)
        cell.onToggleSelection = onToggleSelection
        
        let asset = data[indexPath.row]
        let options = imageFetcherOptions?(asset)
        let fetcher = imageFetcher(asset, options, flowLayout.itemSize)
        
        imageFetcherOperation.cancel(withID: asset)
        imageFetcherOperation.fetchImage(withID: asset, using: fetcher) { image in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func onToggleSelection(_ cell: PhotoLibraryCollectionViewCell) {
        guard let index = collectionView.indexPath(for: cell)?.row else {
            return
        }
        
        toggleSelection(withIndex: index)
    }
    
    private func toggleSelection(withIndex index: Int) {
        guard selectedIndexes[index] == nil else {
            deselectIndex(index)
            return
        }
        
        switch selectionStyle {
        case .single:
            guard let index = selectedIndexes.flatMap({ $0.key }).first else {
                break
            }
            
            deselectIndex(index)
            
        default:
            break
        }
        
        selectIndex(index)
    }
    
    private func selectIndex(_ index: Int) {
        selectedIndexes[index] = true
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        
        guard index >= 0, index < data.count else {
            return
        }
        
        
        onSelectPhoto?(data[index])
    }
    
    private func deselectIndex(_ index: Int) {
        selectedIndexes.removeValue(forKey: index)
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        
        guard index >= 0, index < data.count else {
            return
        }
        
        onDeselectPhoto?(data[index])
    }
    
}

extension PhotoLibraryViewController: UICollectionViewDelegateFlowLayout {
 
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        toggleSelection(withIndex: indexPath.row)
    }
    
}
