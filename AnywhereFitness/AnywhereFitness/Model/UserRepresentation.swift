//
//  UserRepresentation.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    var uid: String
    var firstName: String
    var lastName: String
    var email: String
    var userType: String
    var registrations: [String]?
    var punchcards: [String]?
    var metro: String
    
    init(for user: User) {
        uid = user.uid ?? ""
        firstName = user.firstName ?? ""
        lastName = user.lastName ?? ""
        email = user.email ?? ""
        userType = user.userType ?? ""
        registrations = user.registrations
        punchcards = user.punchcards
        metro = user.metro ?? ""
    }
}
