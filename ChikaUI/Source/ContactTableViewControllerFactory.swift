//
//  ContactTableViewControllerFactory.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class ContactTableViewControllerFactory {

    var style: ContactTableViewController.Style?
    var cellTheme: (() -> ContactTableViewCellTheme)?
    
    var itemAt: ((Int) -> ContactTableViewCellItem)?
    var itemCount: (() -> Int)?
    var onSelectItemAt: ((Int) -> Void)?
    var selectedIndexes: [Int]
    var onDeselectItemAt: ((Int) -> Void)?
    
    public init() {
        self.style = .default
        self.cellTheme = { ContactTableViewCellTheme() }
        self.selectedIndexes = []
    }
    
    public func withStyle(_ style: @escaping () -> ContactTableViewController.Style) -> ContactTableViewControllerFactory {
        self.style = style()
        return self
    }
    
    public func withItemAt(_ itemAt: @escaping (Int) -> ContactTableViewCellItem) -> ContactTableViewControllerFactory {
        self.itemAt = itemAt
        return self
    }
    
    public func withItemCount(_ itemCount: @escaping () -> Int) -> ContactTableViewControllerFactory {
        self.itemCount = itemCount
        return self
    }
    
    public func withCellTheme(_ theme: @escaping () -> ContactTableViewCellTheme) -> ContactTableViewControllerFactory {
        self.cellTheme = theme
        return self
    }
    
    public func withSelectedIndexes(_ indexes: @escaping () -> [Int]) -> ContactTableViewControllerFactory {
        self.selectedIndexes = Array(Set(indexes()))
        return self
    }
    
    public func onSelectItemAt(_ callback: @escaping (Int) -> Void) -> ContactTableViewControllerFactory {
        self.onSelectItemAt = callback
        return self
    }
    
    public func onDeselectItemAt(_ callback: @escaping (Int) -> Void) -> ContactTableViewControllerFactory {
        self.onDeselectItemAt = callback
        return self
    }
    
    public func build() -> ContactTableViewController {
        defer {
            style = nil
            itemAt = nil
            itemCount = nil
            cellTheme = nil
            onSelectItemAt = nil
            onDeselectItemAt = nil
            
            selectedIndexes.removeAll()
        }
        
        let vc = ContactTableViewController()
        
        vc.style = style ?? .default
        vc.cellTheme = cellTheme
        
        vc.prototype = ContactTableViewCell()
        vc.calculator = ContactTableViewCellHeightCalculator()
        
        vc.itemAt = itemAt
        vc.itemCount = itemCount
        vc.onSelectItemAt = onSelectItemAt
        vc.onDeselectItemAt = onDeselectItemAt
        
        vc.select(indexes: selectedIndexes)
        
        return vc
    }
}
