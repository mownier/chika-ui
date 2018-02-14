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
    
    public var style: Style = .default {
        didSet {
            guard isViewLoaded, !deselectAll() else {
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
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.reloadData()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        prototype.bounds.size.width = tableView.bounds.width
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = itemCount?() else {
            return 0
        }
        
        return count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ContactTableViewCell
        let item = itemAt?(indexPath.row)
        cell.layout(withItem: item, isSelectionEnabled: isSelectionEnabled(), isSelected: isSelected(indexPath.row))
        cell.applyTheme(cellTheme())
        cell.onSelectorToggled = onSelectorToggled
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelectItemAt?(indexPath.row)
    }
    
    public override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = itemAt?(indexPath.row)
        return calculator.calulateHeight(for: prototype, item: item, theme: cellTheme?(), isSelectionEnabled: isSelectionEnabled(), isSelected: isSelected(indexPath.row))
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
        }
        
        tableView.reloadData()
        return true
    }
    
    @discardableResult
    public func deselectAll() -> Bool {
        guard isSelectionEnabled(), !selectedIndexes.isEmpty else {
            return false
        }
        
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
        
        indexes.forEach({ selectedIndexes[$0] = true })
        
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
        
        indexes.forEach({ selectedIndexes.removeValue(forKey: $0) })
        
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
