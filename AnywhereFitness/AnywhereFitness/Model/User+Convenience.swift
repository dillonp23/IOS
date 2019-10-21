//
//  User+Convenience.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

enum UserType: String {
    case client
    case instructor
}

extension User {
    // init with a UserType
    convenience init(uid: String, firstName: String, lastName: String, email: String, userType: UserType = .client, metro: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userType = userType.rawValue
        self.metro = metro
        self.registrations = []
        self.punchcards = []
    }
    
    // init with a string for the user type
    convenience init(uid: String, firstName: String, lastName: String, email: String, userType: String = "client", metro: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uid = uid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.userType = userType
        self.metro = metro
        self.registrations = []
        self.punchcards = []
    }
    
    convenience init(representation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uid = representation.uid
        self.firstName = representation.firstName
        self.lastName = representation.lastName
        self.email = representation.email
        self.userType = representation.userType
        self.metro = representation.metro
        self.registrations = representation.registrations
        self.punchcards = representation.punchcards
    }
    
    var representation: UserRepresentation {
        return UserRepresentation(for: self)
    }
}
