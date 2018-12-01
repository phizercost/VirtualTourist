//
//  Global.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/23/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import UIKit
import MapKit

class Global: NSObject {
    
    var session = URLSession.shared
    
    override init() {
        super.init()
    }
    var flickrPictures: [Picture] = []
    var flickrPhotos: ParsedPhotos?
    var pin:Pin?
    static let shared = Global()
}

