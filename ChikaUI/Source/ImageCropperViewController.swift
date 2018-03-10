//
//  ImageCropperViewController.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/10/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import UIKit

public class ImageCropperViewController: UIViewController {
    
    var zoomState: ZoomState = .zoomedOut
    
    var maxZoom: CGFloat = 3.0
    
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    
    public override func loadView() {
        super.loadView()
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = maxZoom
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        
        scrollView.backgroundColor = .gray
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap))
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
    }
    
    public override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
    }
    
    @discardableResult
    public func updateContent() -> Bool {
        return setImage(imageView?.image)
    }
    
    @discardableResult
    public func setImage(_ image: UIImage?) -> Bool {
        guard isViewLoaded else {
            return false
        }
        
        scrollView.backgroundColor = .gray
        zoomState = .zoomedOut
        imageView.image = image
        imageView.frame = .zero
        scrollView.contentSize = .zero
        scrollView.zoomScale = 1.0
        
        guard let imageSize = image?.size else {
            return false
        }
        
        let targetSize = scrollView.bounds.size
        
        let ratioWidth: CGFloat = targetSize.width / imageSize.width
        let ratioHeight: CGFloat = targetSize.height / imageSize.height
        let ratio = max(ratioWidth, ratioHeight)
        
        var rect = CGRect.zero
        rect.size.width = imageSize.width * ratio
        rect.size.height = imageSize.height * ratio
        
        imageView.frame = rect
        scrollView.contentSize = rect.size
        
        scrollToCenter(animated: false)
        
        scrollView.backgroundColor = nil
        
        return true
    }
    
    func scrollToCenter(animated: Bool) {
        var rect = CGRect.zero
        
        rect.origin.x = (scrollView.contentSize.width - scrollView.bounds.width) * 0.5
        rect.origin.y = (scrollView.contentSize.height - scrollView.bounds.height) * 0.5
        rect.size.width = scrollView.bounds.width
        rect.size.height = scrollView.bounds.height
        scrollView.scrollRectToVisible(rect, animated: animated)
    }
    
    @objc func onDoubleTap() {
        switch zoomState {
        case .zoomedIn: zoomState = .zoomedOut
        case .zoomedOut: zoomState = .zoomedIn
        }
        
        let zoom: CGFloat
        
        switch zoomState {
        case .zoomedIn: zoom = maxZoom
        case .zoomedOut: zoom = 1.0
        }
        
        scrollView.setZoomScale(zoom, animated: true)
        scrollToCenter(animated: true)
    }
    
    enum ZoomState {
        
        case zoomedIn
        case zoomedOut
    }
    
}

extension ImageCropperViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}

