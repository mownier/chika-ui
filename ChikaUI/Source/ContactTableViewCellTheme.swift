//
//  ContactTableViewCellTheme.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class ContactTableViewCellTheme {

    public var onlineStatusColor: UIColor?
    
    public var avatarBGColor: UIColor?
    public var avatarBorderColor: UIColor?
    
    public var displayNameFont: UIFont?
    public var displayNameTextColor: UIColor?
    
    public var selectorBorderColor: UIColor?
    public var selectorTintColor: UIColor?
    
    public init() {
        self.onlineStatusColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
        
        self.avatarBGColor = UIColor.clear
        self.avatarBorderColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        self.displayNameFont = UIFont.boldSystemFont(ofSize: 16.0)
        self.displayNameTextColor = UIColor.black
        
        self.selectorTintColor = .white
        self.selectorBorderColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
    }
}
