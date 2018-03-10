//
//  PhotoLibrayImageAssetFetcher.swift
//  ChikaUI
//
//  Created by Mounir Ybanez on 3/2/18.
//  Copyright © 2018 Nir. All rights reserved.
//

import Photos

protocol PhotoLibrayImageAssetFetcher {

    func onImageAssetsChanged(_ block: @escaping ([PHAsset]) -> Void) -> PhotoLibrayImageAssetFetcher
    
    @discardableResult
    func fetchImageAssets(withCompletion completion: @escaping ([PHAsset]) -> Void) -> Bool
    
}

public protocol PhotoLibraryImageFetcher {
    
    @discardableResult
    func fetchImage(withCompletion completion: @escaping (UIImage?) -> Void) -> Bool
 
    @discardableResult
    func cancel() -> Bool

}

class PhotoLibraryImageAssetFetch: NSObject, PhotoLibrayImageAssetFetcher, PHPhotoLibraryChangeObserver {
    
    private var result: PHFetchResult<PHAsset>?
    private var onImageAssetsChanged: (([PHAsset]) -> Void)?
    
    private(set) var library: PHPhotoLibrary
    
    let options: PHFetchOptions?
    
    deinit {
        library.unregisterChangeObserver(self)
        onImageAssetsChanged = nil
    }
    
    init(library: PHPhotoLibrary = .shared(), options: PHFetchOptions? = nil) {
        self.options = options
        self.library = library
        super.init()
        self.library.register(self)
    }
    
    func onImageAssetsChanged(_ block: @escaping ([PHAsset]) -> Void) -> PhotoLibrayImageAssetFetcher {
        onImageAssetsChanged = block
        return self
    }
    
    @discardableResult
    func fetchImageAssets(withCompletion completion: @escaping ([PHAsset]) -> Void) -> Bool {
        let fetchResult = PHAsset.fetchAssets(with: .image, options: options)
        
        handleAssets(withFetchResult: fetchResult, block: completion)
        
        return true
    }
    
    fileprivate func handleAssets(withFetchResult fetchResult: PHFetchResult<PHAsset>, block: @escaping ([PHAsset]) -> Void) {
        var assets = [PHAsset]()
        
        fetchResult.enumerateObjects({ (asset, _, _) in
            assets.append(asset)
        })
        
        result = fetchResult
        
        block(Array(Set(assets)))
    }
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let fetchResult = result
        let handleAssetsBlock = handleAssets
        let onImageAssetsChangedBlock = onImageAssetsChanged
        
        DispatchQueue.main.sync {
            guard fetchResult != nil, let details = changeInstance.changeDetails(for: fetchResult!) else {
                return
            }
            
            let result = details.fetchResultAfterChanges
            
            handleAssetsBlock(result, { assets in
                onImageAssetsChangedBlock?(assets)
            })
        }
    }
    
}

public class PhotoLibraryImageFetch: PhotoLibraryImageFetcher {
    
    public enum TargetSize {
        
        case original
        case custom(CGSize)
    }
    
    public let asset: PHAsset
    public let options: PHImageRequestOptions?
    public let targetSize: TargetSize
    
    public private(set) var requestID: PHImageRequestID?
    
    let imageManager: PHImageManager
    
    public init(imageManager: PHImageManager = .default(), asset: PHAsset, options: PHImageRequestOptions? = nil, targetSize: TargetSize = .original) {
        self.asset = asset
        self.options = options
        self.targetSize = targetSize
        self.imageManager = imageManager
    }
    
    @discardableResult
    public func fetchImage(withCompletion completion: @escaping (UIImage?) -> Void) -> Bool {
        guard requestID == nil else {
            return false
        }
        
        switch targetSize {
        case .custom(let size):
            requestID = imageManager.requestImage(
                for: asset,
                targetSize: size,
                contentMode: .default,
                options: options) { image, _ in
                    completion(image)
            }
        
        case .original:
            requestID = imageManager.requestImageData(
                for: asset,
                options: options) { data, _, _, _ in
                    guard data != nil else {
                        completion(nil)
                        return
                    }
                    
                    completion(UIImage(data: data!))
            }
        }
        
        return true
    }
    
    @discardableResult
    public func cancel() -> Bool {
        guard requestID != nil else {
            return false
        }
        
        imageManager.cancelImageRequest(requestID!)
        return true
    }
    
}

public final class PhotoLibraryImageFetcherOperation<T: Hashable> {
    
    private(set) var fetches: [T: PhotoLibraryImageFetcher]
    
    public init() {
        fetches = [:]
    }
    
    @discardableResult
    public func fetchImage(withID id: T, using fetcher: PhotoLibraryImageFetcher, completion: @escaping (UIImage?) -> Void) -> Bool {
        guard fetches[id] == nil else {
            return false
        }
        
        fetches[id] = fetcher
        
        fetcher.fetchImage { [weak self] image in
            completion(image)
            self?.fetches.removeValue(forKey: id)
        }
        
        return true
    }
    
    @discardableResult
    public func cancel(withID id: T) -> Bool {
        guard let fetch = fetches[id] else {
            return false
        }
        
        fetches.removeValue(forKey: id)
        return fetch.cancel()
    }
    
    @discardableResult
    public func cancelAll() -> Bool {
        guard !fetches.isEmpty else {
            return false
        }
        
        let ok = fetches.reduce(true) { $0 && $1.value.cancel() }
        
        return ok
    }
    
}
