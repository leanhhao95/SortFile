//
//  CleanAsset.swift
//  demoSortFiles
//
//  Created by Hao on 11/10/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import Foundation
import Photos
enum AssetStatus {
    case fetching
    case goodToGo
    case failed
}
private let scale = UIScreen.main.scale
private let cellSize = CGSize(width: 64, height: 64)
private let thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)

class CleanerAsset: Equatable {
    var thumbnailStatus: AssetStatus = .fetching
    var fileSizeStatus: AssetStatus = .fetching
    var asset: PHAsset
    var thumbnail: UIImage?
    var fileSize = 0
    var representedAssetIdentifier: String
    var orderPosition: Int?
    var dateCreatedString = ""
    init(asset: PHAsset, completeBlock: (() -> Void)? = nil) {
        self.asset = asset
        self.representedAssetIdentifier = asset.localIdentifier
        if let date = self.asset.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMMM , yyyy"
            dateCreatedString = dateFormatter.string(from:date)
        }
        fetchImage()
    }
    
    func fetchImage(completeBlock:  (() -> Void)? = nil) {
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: thumbnailSize,
                                              contentMode: .aspectFill,
                                              options: nil)
        { image, info in
            if let image = image {
                if self.representedAssetIdentifier == self.asset.localIdentifier {
                    self.thumbnail = image
                    self.thumbnailStatus = .goodToGo
                    completeBlock?()
                }
            } else if let info = info,
                let _ = info[PHImageErrorKey] as? NSError {
                self.thumbnailStatus = .failed
            }
        }
        print(self.asset.localIdentifier)
    }
    
    
//    func remove(completionHandler: ((Bool, Int, Error?) -> Void)? = nil) {
//        guard let photoService = AppDelegate.shared.photoService else {
//            return
//        }
//        photoService.removeCleanerAsset(self, completionHandler: completionHandler)
//    }
    
    public static func ==(lhs: CleanerAsset, rhs: CleanerAsset) -> Bool {
        return lhs.representedAssetIdentifier == rhs.representedAssetIdentifier
        
    }
    
    
}

