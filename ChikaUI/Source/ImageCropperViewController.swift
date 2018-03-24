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
    
    public var cropSize: CropSize = .`default`
    
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onDoubleTap(_:)))
        tap.numberOfTapsRequired = 2
        
        view.addGestureRecognizer(tap)
    }
    
    public override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
    }
    
    public func crop() -> UIImage? {
        guard isViewLoaded, imageView.image != nil else {
            return nil
        }
        
        var cropArea: CGRect = .zero
        
        switch cropSize {
        case .custom(let size):
            cropArea.size = size
            cropArea.origin.x = (scrollView.bounds.width - size.width) * 0.5 + scrollView.contentOffset.x
            cropArea.origin.y = (scrollView.bounds.height - size.height) * 0.5 + scrollView.contentOffset.y
        
        case .`default`:
            cropArea.size = scrollView.bounds.size
            cropArea.origin.x = scrollView.contentOffset.x
            cropArea.origin.y = scrollView.contentOffset.y
        }
    
        let imageSize = imageView.image!.size
        
        let scale = 1.0 / scrollView.zoomScale;
        let widthRatio = (imageSize.width / imageView.bounds.width) * scale
        let heightRatio = (imageSize.height / imageView.bounds.height) * scale
            
        cropArea.origin.x *= widthRatio
        cropArea.origin.y *= heightRatio
        cropArea.size.width *= widthRatio
        cropArea.size.height *= heightRatio
        
        guard let imageRef = imageView.image!.cgImage?.cropping(to: cropArea) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef)
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
        
        zoomState = .zoomedOut
        
        imageView.image = image
        imageView.frame = .zero
        
        scrollView.zoomScale = 1.0
        scrollView.contentSize = .zero
        scrollView.contentInset.top = 0
        scrollView.contentInset.left = 0
        scrollView.backgroundColor = .gray
        
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
        
        switch cropSize {
        case .custom(let size):
            scrollView.contentInset.top = (targetSize.height - size.height) / 2
            scrollView.contentInset.left = (targetSize.width - size.width) / 2
            rect.size.width += (scrollView.contentInset.left)
            rect.size.height += (scrollView.contentInset.top)
            scrollView.contentSize = rect.size
            
        case .`default`:
            break
        }
        
        scrollView.contentSize = rect.size
        scrollView.backgroundColor = nil
        
        scrollToCenter(animated: false)
        
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
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.bounds.height / scale
        zoomRect.size.width  = imageView.bounds.width  / scale
        let newCenter = scrollView.convert(center, from: imageView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        switch cropSize {
        case .custom:
            zoomRect.origin.x += scrollView.contentOffset.x
            zoomRect.origin.y += scrollView.contentOffset.y
            
        case .`default`:
            break
        }
        
        return zoomRect
    }
    
    @objc func onDoubleTap(_ recognizer: UITapGestureRecognizer) {
        switch zoomState {
        case .zoomedIn: zoomState = .zoomedOut
        case .zoomedOut: zoomState = .zoomedIn
        }
        
        switch zoomState {
        case .zoomedIn:
            scrollView.zoom(to: zoomRectForScale(scale: maxZoom, center: recognizer.location(in: recognizer.view)), animated: true)
            
        case .zoomedOut:
            scrollView.setZoomScale(1.0, animated: true)
            scrollToCenter(animated: true)
        }
        
        switch cropSize {
        case .custom:
            scrollView.contentSize.width += scrollView.contentInset.left
            scrollView.contentSize.height += scrollView.contentInset.top
            
        case .`default`:
            break
        }
    }
    
    enum ZoomState {
        
        case zoomedIn
        case zoomedOut
    }
    
    public enum CropSize {
        
        case `default`
        case custom(CGSize)
    }
    
}

extension ImageCropperViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
