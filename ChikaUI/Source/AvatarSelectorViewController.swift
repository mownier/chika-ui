//
//  AvatarSelectorViewController.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/10/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class AvatarSelectorViewController: UIViewController {

    var imageCropperScene: ImageCropperViewController!
    var photoLibraryScene: PhotoLibraryViewController!
    
    var headerView: AvatarSelectorHeaderView!
    
    public var avatarImage: UIImage? {
        return imageCropperScene?.crop()
    }
    
    public override func loadView() {
        super.loadView()
        
        guard photoLibraryScene != nil, imageCropperScene != nil else {
            return
        }
        
        addChildViewController(imageCropperScene)
        imageCropperScene.didMove(toParentViewController: self)
        
        view.addSubview(photoLibraryScene.view)
        addChildViewController(photoLibraryScene)
        photoLibraryScene.didMove(toParentViewController: self)
        
        headerView = AvatarSelectorHeaderView()
        headerView.circlePadding = 24
        headerView.addSubview(imageCropperScene.view)
        photoLibraryScene.setHeaderView(headerView)
    }
    
    public override func viewDidLayoutSubviews() {
        guard photoLibraryScene != nil, imageCropperScene != nil else {
            return
        }
        
        var rect = CGRect.zero
        
        rect.size.height = min(view.bounds.width, view.bounds.height)
        headerView.frame = rect
        imageCropperScene.view.frame = rect
        imageCropperScene.cropSize = .custom(headerView.cropSize)
        imageCropperScene.updateContent()
        
        rect = view.bounds
        photoLibraryScene.view.frame = rect
    }
    
}
