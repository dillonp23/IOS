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
    
    
    
    
}
