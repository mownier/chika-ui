//
//  ImageCropperViewControllerFactory.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/10/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public final class ImageCropperViewControllerFactory {

    var maxZoom: CGFloat
    
    public init() {
        self.maxZoom = 3.0
    }
    
    @discardableResult
    public func withMaximumZoom(_ zoom: @escaping () -> CGFloat) -> ImageCropperViewControllerFactory {
        maxZoom = zoom()
        maxZoom = maxZoom <= 1.0 ? 1.0 : maxZoom
        return self
    }
    
    public func build() -> ImageCropperViewController {
        let vc = ImageCropperViewController()
        
        vc.maxZoom = maxZoom
        
        return vc
    }
    
}
