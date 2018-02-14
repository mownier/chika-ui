//
//  ContactTableViewCellHeightCalculator.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

class ContactTableViewCellHeightCalculator {
    
    public func calulateHeight(for cell: ContactTableViewCell, item: ContactTableViewCellItem?, theme: ContactTableViewCellTheme?, isSelectionEnabled: Bool, isSelected: Bool) -> CGFloat {
        cell.applyTheme(theme)
        
        if cell.layout(withItem: item, isSelectionEnabled: isSelectionEnabled, isSelected: isSelected, isPrototype: true) {
            return max(cell.avatarView.frame.maxY, cell.displayNameLabel.frame.maxY) + 8
        }
        
        return 0
    }
    
}

