//
//  FitnessClassCollectionViewCell.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/21/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class FitnessClassCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fitnessCategoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeAndDurationLabel: UILabel!
    @IBOutlet weak var btnSignUpCancel: UIButton!
    
    var fitClass: FitClassRepresentation? { didSet { updateViews() } }
    var fitClassController: FitClassController?
    var delegate: UIViewController? //AppHomeViewController?
    var registered: Bool {
        guard let fitClass = fitClass,
            let registeredClients = fitClass.registrants,
            let user = UserController.shared.loggedInUser,
            let uid = user.uid,
            registeredClients.contains(uid)
        else { return false }
        
        return true
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let fitClassController = fitClassController, let fitClass = fitClass,
            let delegate = delegate
        else { return }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if registered {
            // cancel registration
            fitClassController.cancelRegistration(representation: fitClass) { cancelled in
                if cancelled {
                    guard let uid = UserController.shared.loggedInUser?.uid,
                        let i = fitClass.registrants?.firstIndex(of: uid)
                    else { return }
                    DispatchQueue.main.async {
                        self.fitClass?.registrants?.remove(at: i)
                        alert.title = "Registration cancelled"
                        alert.message = "Your registration for this class has been cancelled. Why not choose another one?"
                        self.updateViews()
                    }
                } else {
                    DispatchQueue.main.async {
                        alert.title = "Couldn't cancel!"
                        alert.message = "Sorry, something went wrong and we couldn't cancel your registration. Please try again later."
                    }
                }
            }
        } else {
            // register user for class
            if let maxRegistrants = fitClass.maxRegistrants, let numRegistrants = fitClass.registrants?.count {
                if maxRegistrants >= numRegistrants {
                    DispatchQueue.main.async {
                        alert.title = "Class Full"
                        alert.message = "Sorry, this class is already full. Please select another one."
                    }
                }
            } else {
                fitClassController.registerForClass(representation: fitClass) { registered in
                    DispatchQueue.main.async {
                        if registered {
                            guard let uid = UserController.shared.loggedInUser?.uid else { return }
                            if self.fitClass?.registrants == nil {
                                self.fitClass?.registrants = []
                            }
                            self.fitClass?.registrants?.append(uid)
                            alert.title = "Registered!"
                            alert.message = "You have successfully signed up for \(fitClass.title)!"
                            print("Registered for class: \(fitClass.classID)")
                            self.updateViews()
                        } else {
                            alert.title = "Not Registered :("
                            alert.message = "Sorry, something went wrong and you weren't registered. Please try again later."
                        }
                    }
                }
            }
        }
        DispatchQueue.main.async {
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
            delegate.present(alert, animated: true, completion: nil)
        }
    }
    
    func updateViews() {
        guard let fitClass = fitClass else { return }
        
        DispatchQueue.main.async {
            self.titleLabel.text = fitClass.title
            self.categoryLabel.text = "Class Type: \(fitClass.category)"
            self.intensityLabel.text = "Intensity Level: \(fitClass.intensity.capitalized)"
            self.locationLabel.text = "\(fitClass.city), \(fitClass.state)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, @ h a"
            if let timeSince1970 = Double(fitClass.startTime) {
                let date = Date(timeIntervalSince1970: timeSince1970)
                self.timeAndDurationLabel.text = dateFormatter.string(from: date) + " for \(fitClass.duration) minutes"
            }
            
            self.fitnessCategoryImage.image = UIImage(named: fitClass.category)
            
            if self.registered {
                self.btnSignUpCancel.setTitleColor(.systemPink, for: .normal)
                self.btnSignUpCancel.setTitle("CANCEL >>>", for: .normal)
            } else {
                self.btnSignUpCancel.setTitleColor(UIColor(displayP3Red: 0.337, green: 0.502, blue: 0.914, alpha: 0.9), for: .normal)
                self.btnSignUpCancel.setTitle("SIGN UP >>>", for: .normal)
            }
        }
    }
}
