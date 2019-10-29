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
    
    init() {
        fetchCategoriesFromServer { (error) in
            if let error = error {
                print("Couldn't get categories from server. Using local copy. \(error)")
                self.fetchCategories()
            }
        }
    }
    
    // MARK: - Local Store Methods
    
    private func fetchCategories() {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingCategories = try context.fetch(fetchRequest)
                for category in existingCategories {
                    self.allCategories.append(category.representation)
                }
            } catch {
                fatalError("Couldn't load categories from local store: \(error)")
            }
        }
    }

    func update(category: Category, with representation: CategoryRepresentation) {
        category.name = representation.name
        category.desc = representation.desc
    }
    
    func updateCategories(with representations: [CategoryRepresentation]) {
        let categoriesWithID = representations.filter({ !$0.uuid.isEmpty })
        let identifiersToFetch = categoriesWithID.compactMap({ $0.uuid })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, categoriesWithID))
        var categoriesToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid IN %@", argumentArray: identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        context.perform {
            do {
                let existingCategories = try context.fetch(fetchRequest)
                for category in existingCategories {
                    guard let id = category.uuid,
                        let representation = representationsByID[id.uuidString]
                    else { continue }
                    self.update(category: category, with: representation)
                    categoriesToCreate.removeValue(forKey: id.uuidString)
                    try CoreDataStack.shared.save(context: context)
                }
                
                for representation in categoriesToCreate.values {
                    let _ = Category(from: representation, context: context)
                    try CoreDataStack.shared.save(context: context)
                }
            } catch {
                print("Error fetching categories for UUIDs: \(error)")
            }
        }
    }



    // MARK: - Server Methods

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
//                completion(nil)
            } catch {
                print("Error decoding categories: \(error)")
                completion(error)
                return
            }
            
            self.updateCategories(with: self.allCategories)
            completion(nil)
        }.resume()
    }
    
    
}
