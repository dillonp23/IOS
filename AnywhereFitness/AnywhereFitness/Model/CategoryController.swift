//
//  CategoryController.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/26/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import Foundation
import CoreData

class CategoryController {
    private let baseURL = URL(string: "https://lambda-anywhere-fitness.firebaseio.com/")!
    
    var allCategories: [CategoryRepresentation] = []
    var allCategoriesAsStrings: [String] {
        var stringCats: [String] = []
        for cat in allCategories {
            stringCats.append(cat.name)
        }
        return stringCats
    }
    
    func fetchCategoriesFromServer(completion: @escaping (Error?) -> Void = { _ in }) {
        
        let categoriesURL = baseURL.appendingPathComponent("categories").appendingPathExtension("json")
        var request = URLRequest(url: categoriesURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print("Error fetching categories: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No data when fetching categories")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let categoryDictionary = try decoder.decode([String : CategoryRepresentation].self, from: data)
                for cat in categoryDictionary {
                    self.allCategories.append(cat.value)
                }
                completion(nil)
            } catch {
                print("Error decoding categories: \(error)")
                completion(error)
                return
            }
        }.resume()
    }
}
