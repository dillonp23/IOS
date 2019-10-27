import Foundation
import CoreData


//struct UserRepresentation: Codable {
//    var uid: String
//    var firstName: String
//    var lastName: String
//    var email: String
//    var userType: String
//    var registrations: [String]?
//    var punchcards: [String]?
//    var metro: String
//}

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
    var maxRegistrations: Int?
    var registrants: [String]?
    var offerPunchcard: Bool
}

struct CategoryRepresentation: Codable {
    var uuid: String
    var name: String
    var desc: String?
}

let baseURL = URL(string: "https://lambda-anywhere-fitness.firebaseio.com")!
let type = "categories"

let getRequestURL = baseURL.appendingPathComponent("classes").appendingPathExtension("json")
var allOfThemDic: [String : FitClassRepresentation] = [:]
var allOfThemRep: [FitClassRepresentation] = []
URLSession.shared.dataTask(with: getRequestURL) { (data, res, error) in
    if let error = error {
        print("Error fetching: \(error)")
        return
    }
    
    guard let data = data else {
        print("No data")
        return
    }
    
    let decoder = JSONDecoder()
    do {
        allOfThemDic = try decoder.decode([String : FitClassRepresentation].self, from: data)
    } catch {
        print("Error decoding: \(error)")
        return
    }
    
    for rep in allOfThemDic.values {
        if rep.category == "Marial Arts" {
            let updateURL = baseURL.appendingPathComponent("classes").appendingPathComponent(rep.classID).appendingPathExtension("json")
            var request = URLRequest(url: updateURL)
            request.httpMethod = "PUT"
            var newRep = rep
            newRep.category = "Martial Arts"
            let encoder = JSONEncoder()
            do {
                request.httpBody = try encoder.encode(newRep)
            } catch {
                print("\(rep.classID) failed to encode")
                continue
            }
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("\(rep.classID) failed: \(error)")
                    return
                }
                print("\(rep.classID) updated.")
            }.resume()
        }
    }
}.resume()


/*
func get(oldID: Int) {
    let idString = String(oldID)
    let requestURL = baseURL.appendingPathComponent(type).appendingPathComponent(idString).appendingPathExtension("json")
    
    URLSession.shared.dataTask(with: requestURL) { (data, res, error) in
        if let error = error {
            print("Error fetching \(idString): \(error)")
            return
        }
        
        guard let data = data else {
            print("No data for \(idString)")
            return
        }
        
        var rep: CategoryRepresentation
        let decoder = JSONDecoder()
        do {
            rep = try decoder.decode(CategoryRepresentation.self, from: data)
        } catch {
            print("Error decoding \(idString): \(error)")
            return
        }
        
        put(oldID: oldID, rep: rep)
        print("Got \(idString)")
    }.resume()
}

func put(oldID: Int, rep: CategoryRepresentation) {
    let requestURL = baseURL.appendingPathComponent(type).appendingPathComponent(rep.uuid).appendingPathExtension("json")
    var request = URLRequest(url: requestURL)
    request.httpMethod = "PUT"
    
    let encoder = JSONEncoder()
    do {
        request.httpBody = try encoder.encode(rep)
    } catch {
        print("Error encoding \(String(oldID)): \(error)")
        return
    }
    
    URLSession.shared.dataTask(with: request) { (data, _, error) in
        if let error = error {
            print("Error sending \(String(oldID)): \(error)")
            return
        }
        print("Put \(String(oldID)) to \(rep.uuid)")
        delete(oldID: oldID)
    }.resume()
}

func delete(oldID: Int) {
    let idString = String(oldID)
    let requestURL = baseURL.appendingPathComponent(type).appendingPathComponent(idString).appendingPathExtension("json")
    var request = URLRequest(url: requestURL)
    request.httpMethod = "DELETE"
    
    URLSession.shared.dataTask(with: request) { (_, _, error) in
        if let error = error {
            print("Error deleting \(idString): \(error)")
            return
        }
        print("Deleted \(idString)")
    }.resume()
}


for i in 0...5 {
    get(oldID: i)
}
*/
