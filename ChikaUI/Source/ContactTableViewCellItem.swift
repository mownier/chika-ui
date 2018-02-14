//
//  ContactTableViewCellItem.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/13/18.
//  Copyright © 2018 Nir. All rights reserved.
//

public struct ContactTableViewCellItem {
    
    public var isActive: Bool
    public var avatarURL: String
    public var displayName: String
    
    public init() {
        self.isActive = false
        self.avatarURL = ""
        self.displayName = ""
    }
    
}
