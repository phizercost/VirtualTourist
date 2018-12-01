//
//  Picture+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 12/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//
//

import Foundation
import CoreData


extension Picture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Picture> {
        return NSFetchRequest<Picture>(entityName: "Picture")
    }

    @NSManaged public var photo: NSData?
    @NSManaged public var photoUrl: String?
    @NSManaged public var pin: Pin?
}
