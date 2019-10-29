//
//  FitClassRepresentation.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/20/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation

struct FitClassRepresentation: Codable {
    var classID: String
    var instructor: String
    var startTime: String
    var duration: Int
    var title: String
    var category: String
    var intensity: String
    var metro: String
    var addr1: String
    var addr2: String?
    var city: String
    var state: String
    var zip: String
    var price: Double
    var maxRegistrants: Int?
    var registrants: [String]?
    var offerPunchcard: Bool
    
    init(for fitClass: FitClass) {
        classID = fitClass.classID?.uuidString ?? ""
        instructor = fitClass.instructor?.uuidString ?? ""
        startTime = fitClass.startTime ?? ""
        duration = Int(fitClass.duration)
        title = fitClass.title ?? ""
        category = fitClass.category ?? ""
        intensity = fitClass.intensity ?? ""
        metro = fitClass.metro ?? ""
        addr1 = fitClass.addr1 ?? ""
        addr2 = fitClass.addr2 ?? ""
        city = fitClass.city ?? ""
        state = fitClass.state ?? ""
        zip = fitClass.zip ?? ""
        price = fitClass.price
        maxRegistrants = Int(fitClass.maxRegistrants)
        registrants = fitClass.registrants
        offerPunchcard = fitClass.offerPunchcard
    }
    
    init(classID: String, instructor: String, startTime: String, duration: Int, title: String, category: String, intensity: String, metro: String, addr1: String, addr2: String? = nil, city: String, state: String, zip: String, price: Double, maxRegistrants: Int? = nil, registrants: [String]? = nil, offerPunchcard: Bool = false) {
        
        self.classID = classID
        self.instructor = instructor
        self.startTime = startTime
        self.duration = duration
        self.title = title
        self.category = category
        self.intensity = intensity
        self.metro = metro
        self.addr1 = addr1
        self.addr2 = addr2
        self.city = city
        self.state = state
        self.zip = zip
        self.price = price
        self.maxRegistrants = maxRegistrants
        self.registrants = registrants
        self.offerPunchcard = offerPunchcard
    }
}
