//
//  SelectedContactCarouselCellTheme.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/16/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class SelectedContactCarouselCellTheme {

    public var backgroundColor: UIColor?
    
    public var avatarBGColor: UIColor?
    public var avatarBorderColor: UIColor?
    
    public var displayNameFont: UIFont?
    public var displayNameTextColor: UIColor?
    
    public var removeActionBGColor: UIColor?
    public var removeActionMinusIconTintColor: UIColor?
    
    public init() {
        self.backgroundColor = UIColor.white
        
        self.avatarBGColor = UIColor.clear
        self.avatarBorderColor = UIColor.lightGray.withAlphaComponent(0.5)
        
        self.displayNameFont = UIFont.boldSystemFont(ofSize: 16.0)
        self.displayNameTextColor = UIColor.black
        
        self.removeActionBGColor = UIColor(red: 255/255, green: 59/255, blue: 48/255, alpha: 1)
        self.removeActionMinusIconTintColor = UIColor.white
    }
    
}
