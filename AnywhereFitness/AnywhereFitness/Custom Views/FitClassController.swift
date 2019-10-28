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
    
    static var shared = FitClassController()
    private let baseURL = URL(string: "https://lambda-anywhere-fitness.firebaseio.com/")!
    
    var fitClassRepresentations: [FitClassRepresentation] = []
    var fitClassRepsForUserMetro: [FitClassRepresentation] {
        guard let user = UserController.shared.loggedInUser,
            let metro = user.metro, !metro.isEmpty
        else {
            // if the user isn't logged in, return everything
            return fitClassRepresentations
        }
        return classRepsFor(metro: metro)
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
                self.fitClassRepresentations.removeAll()
                let fitClassDictionary = try decoder.decode([String: FitClassRepresentation].self, from: data)
                
                for fitClass in fitClassDictionary {
                    self.fitClassRepresentations.append(fitClass.value)
                }
                
                completion(nil)
            } catch {
                print("Error decoding fitness class data: \(error)")
                completion(error)
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
            if rep.metro == metro && rep.category.lowercased() == category.lowercased() && Date(timeIntervalSinceReferenceDate: timestamp) > Date() {
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
    
    func updateRepresentation(with rep: FitClassRepresentation) {
        guard let i = fitClassRepresentations.firstIndex(where: { $0.classID == rep.classID }) else { return }
        fitClassRepresentations[i] = rep
    }
        
    // MARK: - Create/Update/Register/Cancel
    
    func createOrUpdateFitClass(with representation: FitClassRepresentation, completion: @escaping (Bool) -> Void) {
        let requestURL = baseURL.appendingPathComponent("classes").appendingPathComponent(representation.classID).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(representation)
        } catch {
            print("Error encoding new or updated class: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error saving new/updated class: \(error)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
   
    func registerForClass(representation: FitClassRepresentation, completion: @escaping (Bool) -> Void) {
        guard let user = UserController.shared.loggedInUser, let uid = user.uid
        else {
            completion(false)
            return
        }
        
        if let max = representation.maxRegistrants, let registered = representation.registrants?.count {
            if max >= registered {
                completion(false)
                return
            }
        }
        
        var updatedRep = representation
        if updatedRep.registrants == nil {
            updatedRep.registrants = []
        }
        updatedRep.registrants?.append(uid)
        
        let updateURL = baseURL.appendingPathComponent("classes").appendingPathComponent(representation.classID).appendingPathExtension("json")
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(updatedRep)
            
        } catch {
            print("Unable to encode rep when registering for class: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, res, error) in
            if let error = error {
                print("Error updating class registrations: \(error)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }
    
    func cancelRegistration(representation: FitClassRepresentation, completion: @escaping (Bool) -> Void) {
        guard let user = UserController.shared.loggedInUser,
            let uid = user.uid,
            var currentRegistrants = representation.registrants
        else {
            completion(false)
            return
        }
        
        var updatedRep = representation
        let i = currentRegistrants.firstIndex(of: uid)
        if let i = i {
            currentRegistrants.remove(at: i)
        }
        updatedRep.registrants = currentRegistrants
        
        let updateURL = baseURL.appendingPathComponent("classes").appendingPathComponent(representation.classID).appendingPathExtension("json")
        var request = URLRequest(url: updateURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(updatedRep)
        } catch {
            print("Unable to encode rep when registering for class: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, res, error) in
            if let error = error {
                print("Error updating class registrations: \(error)")
                completion(false)
                return
            }
            print(res ?? "No response")
            self.updateRepresentation(with: updatedRep)
            completion(true)
        }.resume()
    }
}
