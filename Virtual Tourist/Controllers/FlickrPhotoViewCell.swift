//
//  FlickrPhotoViewCell.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/24/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit

class FlickrPhotoViewCell: UICollectionViewCell {
    static let identifier = "FlickrPhotoViewCell"
    
    var url: String = ""
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
}
