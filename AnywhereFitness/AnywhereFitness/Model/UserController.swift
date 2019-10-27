//
//  UserController.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/21/19.
//  Copyright © 2019 Julltron. All rights reserved.
//
import Foundation
import CoreData

class UserController {
    static var shared = UserController()
    
    private let baseURL = URL(string: "https://lambda-anywhere-fitness.firebaseio.com/")!

    var loggedInUser: User?
    var fetchedUser: User?
    var fetchedUsers: [User] = []
    
    // MARK: - Local store methods
    
    // UID should be provided from authentication system!
    func createUser(uid: String, firstName: String, lastName: String, email: String, userType: UserType, metro: String,
                    context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        let user = User(uid: uid, firstName: firstName, lastName: lastName, email: email, userType: userType, metro: metro, context: context)
        context.perform {
            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                print("Unable to save new user: \(error)")
                context.reset()
            }
        }
        put(user: user)
        fetchedUser = user
    }
    
    func checkPreviousSignIn(completion: @escaping (Bool) -> Void) {
        // checks for a previous sign in. If one (and only one) exists,
        // sets that user to the loggedInUser and returns true to completion.
        // Otherwise, returns false
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let context = CoreDataStack.shared.mainContext
        context.perform {
            do {
                let existingUsers = try context.fetch(fetchRequest)
                if existingUsers.count != 1 {
                    completion(false)
                    return
                }
                for entry in existingUsers {
                    self.loggedInUser = entry
                    print("Signed in: \(entry)")
                    completion(true)
                }
            } catch {
                completion(false)
                return
            }
        }
    }
    
    func login(_ user: User? = nil) {
        // logs in the last fetchedUser if no user is specified
        
        if let user = user {
            loggedInUser = user
        } else {
            loggedInUser = fetchedUser
        }
    }
    
    // MARK: - Server methods
    
    func put(user: User, completion: @escaping (Error?) -> Void = { _ in }) {
        put(rep: user.representation, completion: completion)
    }
    
    func put(rep: UserRepresentation, completion: @escaping (Error?) -> Void = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent(rep.uid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(rep)
        } catch {
            print("Error encoding user representation: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error sending user to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func deleteFromServer(user: User, completion: @escaping (Error?) -> Void = { _ in }) {
        guard let uid = user.uid else {
            completion(nil)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent(uid).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print("Error deleting user from servier: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchOneUser(uid: String, completion: @escaping (Error?) -> Void) {
        // Saves the last requested user to the fetchedUser property and then calls the completion
        let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent(uid).appendingPathExtension("json")
        
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                print("Error fetching user \(uid): \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                print("No user returned by data task :(")
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            var rep: UserRepresentation
            do {
                rep = try decoder.decode(UserRepresentation.self, from: data)
            } catch {
                print("Error decoding user representation: \(error)")
                completion(error)
                return
            }
            
            self.fetchedUser = User(representation: rep)
            completion(nil)
        }.resume()
    }
    
    func fetchSomeUsers(uids: [String], completion: @escaping (Error?) -> Void) {
        // Saves the users requested to the fetchedUsers array and then calls the completion
        fetchedUsers = []
        for uid in uids {
            let requestURL = baseURL.appendingPathComponent("users").appendingPathComponent(uid).appendingPathExtension("json")
            URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
                if let error = error {
                    print("Error getting \(uid): \(error)")
                } else {
                    if let data = data {
                        let decoder = JSONDecoder()
                        var rep: UserRepresentation
                        do {
                            rep = try decoder.decode(UserRepresentation.self, from: data)
                        } catch {
                            print("No data for \(uid)")
                            return
                        }
                        self.fetchedUsers.append(User(representation: rep))
                    }
                }
            }
        }
    }
}
