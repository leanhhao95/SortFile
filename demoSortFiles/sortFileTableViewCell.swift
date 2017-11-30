//
//  sortFileTableViewCell.swift
//  demoSortFiles
//
//  Created by Hao on 11/5/17.
//  Copyright © 2017 Hao. All rights reserved.
//

import UIKit

class sortFileTableViewCell: UITableViewCell {

    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var typeAssetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        sizeLabel.text = ""
        typeAssetLabel.text = ""
        photoImageView.image = nil
    }
}
class ImageCell: sortFileTableViewCell {
    override func prepareForReuse() {
        sizeLabel.text = ""
        typeAssetLabel.text = "Photo"
        photoImageView.image = nil
    }
}

class VideoCell: sortFileTableViewCell {
    override func prepareForReuse() {
        sizeLabel.text = ""
        typeAssetLabel.text = "Video"
        photoImageView.image = nil
    }
}
