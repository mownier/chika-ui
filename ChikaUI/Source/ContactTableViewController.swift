//
//  ContactTableViewController.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class ContactTableViewController: UITableViewController {

    public enum Style: Int {
        
        case `default`
        case selection
    }
    
    var cellTheme: (() -> ContactTableViewCellTheme)!
    var prototype: ContactTableViewCell!
    var calculator: ContactTableViewCellHeightCalculator!
    
    var itemAt: ((Int) -> ContactTableViewCellItem)!
    var itemCount: (() -> Int)!
    var onSelectItemAt: ((Int) -> Void)!
    var onDeselectItemAt: ((Int) -> Void)!
    
    var selectedIndexes: [Int: Bool] = [:]
    
    public var isPlaceholderCellShown: Bool = false {
        didSet {
            guard isViewLoaded else {
                return
            }
            
            tableView.reloadData()
        }
    }
    
    public var style: Style = .default {
        willSet {
            guard isViewLoaded else {
                return
            }
            
            deselectAll()
        }
        didSet {
            guard isViewLoaded else {
                return
            }
            
            tableView.reloadData()
        }
    }
    
    public var selections: [Int] {
        return selectedIndexes.flatMap({ $0.key })
    }
    
    public override func loadView() {
        super.loadView()
        
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 0
        tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.register(ContactTableViewCellPlaceholder.self, forCellReuseIdentifier: "CellPlaceholder")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prototype.bounds.size.width = tableView.bounds.width
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let count = itemCount?() else {
                return 0
            }
            
            return count
        
        case 1:
            return (isPlaceholderCellShown ? 1 : 0)
        
        default:
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContactTableViewCell
            let item = itemAt?(indexPath.row)
            cell.layout(withItem: item, isSelectionEnabled: isSelectionEnabled(), isSelected: isSelected(indexPath.row))
            cell.applyTheme(cellTheme())
            cell.onSelectorToggled = onSelectorToggled
            
            return cell
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellPlaceholder") as! ContactTableViewCellPlaceholder
            return cell
        
        default:
            return UITableViewCell()
        }

    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard style != .selection else {
                return
            }
            
            onSelectItemAt?(indexPath.row)
        
        default:
            break
        }
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            let item = itemAt?(indexPath.row)
            return calculator.calulateHeight(for: prototype, item: item, theme: cellTheme?(), isSelectionEnabled: isSelectionEnabled(), isSelected: isSelected(indexPath.row))
        
        default:
            return 56
        }
        
    }
    
    public func dispose() {
        itemAt = nil
        itemCount = nil
        onSelectItemAt = nil
        onDeselectItemAt = nil
    }
    
    @discardableResult
    public func selectAll() -> Bool {
        guard isSelectionEnabled(), let count = itemCount?(), count > 0 else {
            return false
        }
        
        for index in 0..<count {
            selectedIndexes[index] = true
            onSelectItemAt?(index)
        }
        
        tableView.reloadData()
        return true
    }
    
    @discardableResult
    public func deselectAll() -> Bool {
        guard isSelectionEnabled(), !selectedIndexes.isEmpty else {
            return false
        }
        
        selectedIndexes.forEach({ onDeselectItemAt?($0.key) })
        selectedIndexes.removeAll()
        tableView.reloadData()
        return true
    }
    
    @discardableResult
    public func select(indexes: [Int]) -> Bool {
        let indexes = Array(Set(indexes))
        
        guard isSelectionEnabled(), let count = itemCount?(), !indexes.isEmpty, indexes.filter({ $0 < count }) == indexes else {
            return false
        }
        
        indexes.forEach({
            selectedIndexes[$0] = true
            onSelectItemAt?($0)
        })
        
        if isViewLoaded {
            tableView.reloadData()
        }
        
        return true
    }
    
    @discardableResult
    public func deselect(indexes: [Int]) -> Bool {
        let indexes = Array(Set(indexes))
        
        guard isSelectionEnabled(), !selectedIndexes.isEmpty, !indexes.isEmpty, indexes.filter({ selectedIndexes[$0] != nil }) == indexes else {
            return false
        }
        
        indexes.forEach({
            selectedIndexes.removeValue(forKey: $0)
            onDeselectItemAt?($0)
        })
        
        if isViewLoaded {
            tableView.reloadData()
        }
        
        return true
    }
    
    func onSelectorToggled(_ cell: ContactTableViewCell) {
        guard isSelectionEnabled(), let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        let index = indexPath.row
        
        if selectedIndexes.contains(where: { $0.key == index }) {
            selectedIndexes.removeValue(forKey: index)
            onDeselectItemAt?(index)
        
        } else {
            selectedIndexes[index] = true
            onSelectItemAt?(index)
        }
        
        updateCell(at: indexPath)
    }
    
    func updateCell(at indexPath: IndexPath) {
        let rows = [indexPath]
        tableView.beginUpdates()
        tableView.reloadRows(at: rows, with: .none)
        tableView.endUpdates()
    }
    
    func isSelected(_ index: Int) -> Bool {
        return selectedIndexes.contains(where: { $0.key == index })
    }
    
    func isSelectionEnabled() -> Bool {
         return style == .selection
    }
    
}
