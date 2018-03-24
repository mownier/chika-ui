//
//  AvatarSelectorViewControllerFactory.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/10/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class AvatarSelectorViewControllerFactory {

    public init() {
    }
    
    public func build() -> AvatarSelectorViewController {
        let vc = AvatarSelectorViewController()
        
        let imageCropperFactory = ImageCropperViewControllerFactory()
        vc.imageCropperScene = imageCropperFactory.withMaximumZoom({
            5.0
        }).build()
        
        let photoLibraryFactory = PhotoLibraryViewControllerFactory()
        vc.photoLibraryScene = photoLibraryFactory.withColumns({
            4
            
        }).withItemSpacing({
            2
            
        }).withSelectionStyle({
            .single
            
        }).onSelectPhoto({ asset in
            vc.imageCropperScene.cropSize = .custom(vc.headerView.cropSize)
            vc.imageCropperScene.updateContent()
            
            let fetcher = PhotoLibraryImageFetch(asset: asset)
            fetcher.fetchImage { image in
                 vc.imageCropperScene.setImage(image)
            }
            
        }).onDeselectPhoto({ _ in
            vc.imageCropperScene.setImage(nil)
        
        }).build()
        
        return vc
    }
}
