//
//  CategoryRepresentation.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation

struct CategoryRepresentation: Codable {
    var uuid: String
    var name: String
    var desc: String?
    
    init(for category: Category) {
        self.uuid = category.uuid?.uuidString ?? ""
        self.name = category.name ?? ""
        self.desc = category.desc ?? ""
    }
}
