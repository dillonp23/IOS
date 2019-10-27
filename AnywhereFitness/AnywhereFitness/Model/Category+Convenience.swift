//
//  Category+Convenience.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    convenience init(uuid: String, name: String, desc: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = UUID(uuidString: uuid)
        self.name = name
        self.desc = desc
    }
    
    convenience init(from representation: CategoryRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        self.uuid = UUID(uuidString: representation.uuid)
        self.name = representation.name
        self.desc = representation.desc
    }
    
    var representation: CategoryRepresentation {
        return CategoryRepresentation(for: self)
    }
}
