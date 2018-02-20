//
//  SelectedContactCarouselFactory.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 2/16/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class SelectedContactCarouselFactory {

    var itemAt: ((Int) -> SelectedContactCarouselCellItem)?
    var itemSize: (() -> CGSize)?
    var itemCount: (() -> Int)?
    var cellTheme: (() -> SelectedContactCarouselCellTheme)?
    var onRemoveItemAt: ((Int) -> Bool)?
    var placeholderCellText: (() -> String)?
    
    public init() {
        self.itemSize = { CGSize(width: 100, height: 128) }
        self.cellTheme = { SelectedContactCarouselCellTheme() }
        self.placeholderCellText = { "Select Contact" }
    }
    
    public func withItemAt(_ block: @escaping (Int) -> SelectedContactCarouselCellItem) -> SelectedContactCarouselFactory {
        itemAt = block
        return self
    }
    
    public func withItemSize(_ block: @escaping () -> CGSize) -> SelectedContactCarouselFactory {
        itemSize = block
        return self
    }
    
    public func withItemCount(_ block: @escaping () -> Int) -> SelectedContactCarouselFactory {
        itemCount = block
        return self
    }
    
    public func withCellTheme(_ block: @escaping () -> SelectedContactCarouselCellTheme) -> SelectedContactCarouselFactory {
        cellTheme = block
        return self
    }
    
    public func onRemoveItemAt(_ block: @escaping (Int) -> Bool) -> SelectedContactCarouselFactory {
        onRemoveItemAt = block
        return self
    }
    
    public func withPlaceholderCellText(_ block: @escaping () -> String) -> SelectedContactCarouselFactory {
        placeholderCellText = block
        return self
    }
    
    public func build() -> SelectedContactCarousel {
        defer {
            itemAt = nil
            itemSize = nil
            itemCount = nil
            cellTheme = nil
            onRemoveItemAt = nil
            placeholderCellText = nil
        }
        
        let carousel = SelectedContactCarousel()
        
        carousel.itemAt = itemAt
        carousel.itemSize = itemSize
        carousel.itemCount = itemCount
        carousel.cellTheme = cellTheme
        carousel.onRemoveItemAt = onRemoveItemAt
        carousel.placeholderCellText = placeholderCellText
        
        return carousel
    }
    
}
