//
//  PhotoLibraryViewControllerFactory.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/3/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit
import Photos

public final class PhotoLibraryViewControllerFactory {

    var onSelectPhoto: ((PHAsset) -> Void)?
    var onDeselectPhoto: ((PHAsset) -> Void)?
    
    var columns: CGFloat
    var itemSpacing: CGFloat
    
    var selectionStyle: PhotoLibraryViewController.SelectionStyle
    
    var headerView: UIView?
    
    public init() {
        self.columns = 3
        self.itemSpacing = 1
        
        self.selectionStyle = .multiple
    }
    
    public func onSelectPhoto(_ block: @escaping (PHAsset) -> Void) -> PhotoLibraryViewControllerFactory {
        onSelectPhoto = block
        return self
    }
    
    public func onDeselectPhoto(_ block: @escaping (PHAsset) -> Void) -> PhotoLibraryViewControllerFactory {
        onDeselectPhoto = block
        return self
    }
    
    public func withColumns(_ block: @escaping () -> CGFloat) -> PhotoLibraryViewControllerFactory {
        columns = block()
        return self
    }
    
    public func withItemSpacing(_ block: @escaping () -> CGFloat) -> PhotoLibraryViewControllerFactory {
        itemSpacing = block()
        return self
    }
    
    public func withSelectionStyle(_ block: @escaping () -> PhotoLibraryViewController.SelectionStyle) -> PhotoLibraryViewControllerFactory {
        selectionStyle = block()
        return self
    }
    
    public func withHeaderView(_ block: @escaping () -> UIView) -> PhotoLibraryViewControllerFactory {
        headerView = block()
        return self
    }
    
    public func build() -> PhotoLibraryViewController {
        defer {
            headerView = nil
            onSelectPhoto = nil
            onDeselectPhoto = nil
        }
        
        let vc = PhotoLibraryViewController()
        
        vc.columns = columns
        vc.itemSpacing = itemSpacing
        
        vc.imageFetcher = { PhotoLibraryImageFetch(asset: $0, options: $1, targetSize: .custom($2)) }
        vc.imageAssetFetcher = { PhotoLibraryImageAssetFetch(options: $0) }
        
        vc.onSelectPhoto = onSelectPhoto
        vc.onDeselectPhoto = onDeselectPhoto
        
        vc.selectionStyle = selectionStyle
        
        if headerView != nil {
            vc.setHeaderView(headerView!)
        }
        
        return vc
    }
    
}
