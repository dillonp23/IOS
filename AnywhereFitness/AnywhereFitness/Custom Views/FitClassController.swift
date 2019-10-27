//
//  FitClassController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/21/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase

class FitClassController {
    
    private let baseURL = URL(string: "https://lambda-anywhere-fitness.firebaseio.com/")!
    
    var fitClassRepresentations: [FitClassRepresentation] = []
    
    func searchClasses(completion: @escaping (Error?) -> Void = { _ in }) {
        
        
    }
    
    
    func fetchClassesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let classesURL = baseURL.appendingPathComponent("classes")
        let requestURL = classesURL.appendingPathExtension("json")
        
        var request = URLRequest(url: requestURL)
        
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                print("Error fetching entries: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(nil)
                return
            }
            
            
            
            let decoder = JSONDecoder()
            
            do {
                let fitClassDictionary = try decoder.decode([String: FitClassRepresentation].self, from: data)
                
                for fitClass in fitClassDictionary {
                    self.fitClassRepresentations.append(fitClass.value)
                }
                
                completion(nil)
            } catch {
                print("Error decoding fitness class data: \(error)")
            }
            
        }.resume()
        
    }
    
    // MARK: - Search functionality
    
    func classRepsFor(metro: String) -> [FitClassRepresentation] {
        // returns all classes occurring in the future that have a matching metro
        
        return fitClassRepresentations.filter { (rep) -> Bool in
            guard let timestamp = Double(rep.startTime) else { return false }
            if rep.metro == metro && Date(timeIntervalSinceReferenceDate: timestamp) > Date() {
                return true
            }
            return false
        }
    }
    
    func classRepsFor(category: String, metro: String) -> [FitClassRepresentation] {
        // returns all classes occurring in the future that have a matching category and metro
        
        return fitClassRepresentations.filter { (rep) -> Bool in
            guard let timestamp = Double(rep.startTime) else { return false }
            if rep.metro == metro && rep.category == category && Date(timeIntervalSinceReferenceDate: timestamp) > Date() {
                return true
            }
            return false
        }
    }
    
    func classRepsFor(client: User, includePastClasses: Bool = false) -> [FitClassRepresentation] {
        // returns all classes that list the user as a registrant
        guard let uid = client.uid else { return [] }
        
        return fitClassRepresentations.filter { (rep) -> Bool in
            guard let timestamp = Double(rep.startTime), let registrants = rep.registrants else { return false }
            
            if registrants.contains(uid) {
                if includePastClasses || Date(timeIntervalSinceReferenceDate: timestamp) > Date() {
                    return true
                }
            }
            return false
        }
    }
}
