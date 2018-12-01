//
//  Photos.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/24/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation
import MapKit

struct PinPhotos {
    var pin: MKPointAnnotation
    var photos: Photos
    
    init(forPin: MKPointAnnotation, photo: Photos){
        pin = forPin
        photos = photo
    }
}
