//
//  ParsedPhoto.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 11/24/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//

import Foundation

struct ParsedPhotos: Codable {
    let photos: Photos
}

struct Photos: Codable {
    let pages: Int
    let photo: [ParsedPhoto]
}

struct ParsedPhoto: Codable {
    
    let url: String?
    enum CodingKeys: String, CodingKey {
        case url = "url_n"
    }
}
