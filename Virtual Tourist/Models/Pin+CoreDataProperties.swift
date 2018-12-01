//
//  Pin+CoreDataProperties.swift
//  Virtual Tourist
//
//  Created by Phizer Cost on 12/1/18.
//  Copyright © 2018 Phizer Cost. All rights reserved.
//
//

import Foundation
import CoreData


extension Pin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pin> {
        return NSFetchRequest<Pin>(entityName: "Pin")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var pictures: NSSet?

}

// MARK: Generated accessors for pictures
extension Pin {

    @objc(addPicturesObject:)
    @NSManaged public func addToPictures(_ value: Picture)

    @objc(removePicturesObject:)
    @NSManaged public func removeFromPictures(_ value: Picture)

    @objc(addPictures:)
    @NSManaged public func addToPictures(_ values: NSSet)

    @objc(removePictures:)
    @NSManaged public func removeFromPictures(_ values: NSSet)

}
