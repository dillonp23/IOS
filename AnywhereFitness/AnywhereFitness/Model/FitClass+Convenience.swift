//
//  FitClass+Convenience.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

extension FitClass {
    convenience init(classID: String, instructor: String, startTime: String, duration: Int, title: String, category: String, intensity: String, metro: String, addr1: String, addr2: String? = nil, city: String, state: String, zip: String, price: Double, maxRegistrants: Int? = nil, registrants: [String]? = nil, offerPunchcard: Bool = false, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
//        guard let dblStartTime = Double(startTime) else {
//            self.init()
//            return
//        }
        
        self.init(context: context)
        self.classID = UUID(uuidString: classID)
        self.instructor = UUID(uuidString: instructor)
        self.startTime = startTime  //Date(timeIntervalSince1970: dblStartTime)
        self.duration = Int16(duration)
        self.title = title
        self.category = category
        self.intensity = intensity
        self.metro = metro
        self.addr1 = addr1
//        self.addr2 = addr2
        self.city = city
        self.state = state
        self.zip = zip
        self.price = price
//        self.maxRegistrants = Int16(truncating: NSNumber(nonretainedObject: maxRegistrants))
//        self.registrants = registrants
        self.offerPunchcard = offerPunchcard
    }
    
    convenience init(representation: FitClassRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.classID = UUID(uuidString: representation.classID)
        self.instructor = UUID(uuidString: representation.instructor)
        self.startTime = representation.startTime  //Date(timeIntervalSince1970: dblStartTime)
        self.duration = Int16(representation.duration)
        self.title = representation.title
        self.category = representation.category
        self.intensity = representation.intensity
        self.metro = representation.metro
        self.addr1 = representation.addr1
//        self.addr2 = representation.addr2
        self.city = representation.city
        self.state = representation.state
        self.zip = representation.zip
        self.price = representation.price
//        self.maxRegistrants = Int16(truncating: NSNumber(nonretainedObject: representation.maxRegistrants))
//        self.registrants = representation.registrants
        self.offerPunchcard = representation.offerPunchcard
    }
    
    var representation: FitClassRepresentation {
        return FitClassRepresentation(for: self)
    }
}
