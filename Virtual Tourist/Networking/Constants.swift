//
//  Constants.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/24/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation


struct Constants {
    
    struct Flickr {
        static let photoSearchUrl = "https://api.flickr.com/services/rest?"
        static let APIKey = "3c25dfaad9f0d927bc78ff53890c8006"
        static let accuracy = "1"
        static let format = "json"
        static let jsoncallback = "1"
        static let page = "1"
        static let extras = "url_n"
        static let safe_search = "1"
        static let photosPerPage = "25"
        static let method = "flickr.photos.search"
    }
}
