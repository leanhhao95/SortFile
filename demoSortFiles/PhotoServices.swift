//
//  PhotoServices.swift
//  demoSortFiles
//
//  Created by Admin on 11/27/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import Foundation
import Photos

class PhotoServices : NSObject {
    var isFetching : Bool = false
    var shouldShowActivity = true
    fileprivate let concurrentCleanerAssetQueue =
        DispatchQueue(
            label: "com.bababibo.CleanerAsset.cleanerAssetQueue",
            attributes: .concurrent)
    var fetchResult : PHFetchResult<PHAsset>?
    private var _displayedAssets : [CleanerAsset] = [] {
        didSet {
            guard !isDeleting else {return}
            NotificationCenter.default.post(name: Notification.Name.didFinishFetchPHAsset, object: nil)
        }
    }
    var displayedAssets : [CleanerAsset] {
        get {
            var displayedAssetsCopy : [CleanerAsset]!
                displayedAssetsCopy = self._displayedAssets
            return displayedAssetsCopy
        }
        set {
                self._displayedAssets = newValue
        }
    }
    override init() {
        super.init()
        requestAuthorization()
    }

    var isDeleting = false
    var isRemoving = false
    func requestAuthorization() {
        PHPhotoLibrary.requestAuthorization { [unowned self] (status) in
            switch status {
            case .authorized:
                self.fetchAsset()
            case .denied:
                fallthrough
            case .notDetermined:
                fallthrough
            case .restricted:
                print("false")
            }
        }
    }
    func addCleanerAsset(_ cleanerAsset : CleanerAsset) {
        concurrentCleanerAssetQueue.async(flags: .barrier) {
            self._displayedAssets.append(cleanerAsset)
        }
    }
    
    func fetchAsset() {
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "duration", ascending: false)]
        self.fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        updateDisplayedAssets(fetchResult: fetchResult!)
    }
    func updateDisplayedAssets(fetchResult: PHFetchResult<PHAsset>) {
        let count = fetchResult.count
        guard fetchResult.count > 0 else { return }
        guard isFetching == false else {return}
        isFetching = true
        self.displayedAssets = []
        let downloadGroup = DispatchGroup()
        for index in 0 ..< count {
            downloadGroup.enter()
            addCleanerAsset(CleanerAsset(asset: fetchResult.object(at: index), completeBlock: {
                downloadGroup.leave()
            }))
        }
        downloadGroup.notify(queue: DispatchQueue.main) {
            self.didFinishUpdate()
        }
    }
    func didFinishUpdate() {
        self.displayedAssets = self.displayedAssets.sorted(by: {$0.fileSize > $1.fileSize})
        self.isFetching = false
        self.isRemoving = false
    }
}
extension Notification.Name {
    static let didFinishFetchPHAsset = Notification.Name.init("didFinishFetchPHAsset")

}
