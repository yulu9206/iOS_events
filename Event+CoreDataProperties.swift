//
//  Event+CoreDataProperties.swift
//  Events
//
//  Created by Lu Yu on 7/21/17.
//  Copyright © 2017 Lu Yu. All rights reserved.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var ttl: String?
    @NSManaged public var info: String?
    @NSManaged public var time: NSDate?
    @NSManaged public var cmp: Bool

}
