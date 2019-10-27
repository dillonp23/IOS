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
    var delegate: UIViewController?
    var registered = false
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let fitClassController = fitClassController, let fitClass = fitClass,
            let delegate = delegate
        else { return }
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if registered {
            // cancel registration
            fitClassController.cancelRegistration(representation: fitClass) { cancelled in
                if cancelled {
                    DispatchQueue.main.async {
                        alert.title = "Registration cancelled"
                        alert.message = "Your registration for this class has been cancelled. Why not choose another one?"
                        self.registered = false
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
                            alert.title = "Registered!"
                            alert.message = "You have successfully signed up for \(fitClass.title)!"
                            self.registered = true
                            print("Registered for class: \(fitClass.classID)")
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
        guard let fitClass = fitClass,
            let user = UserController.shared.loggedInUser,
            let uid = user.uid,
            let registrants = fitClass.registrants
        else { return }
        
        titleLabel.text = fitClass.title
        categoryLabel.text = "Class Type: \(fitClass.category)"
        intensityLabel.text = "Intensity Level: \(fitClass.intensity.capitalized)"
        locationLabel.text = "\(fitClass.city), \(fitClass.state)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, @ h a"
        if let timeSince1970 = Double(fitClass.startTime) {
            let date = Date(timeIntervalSince1970: timeSince1970)
            timeAndDurationLabel.text = dateFormatter.string(from: date) + " for \(fitClass.duration) minutes"
        }
        
        fitnessCategoryImage.image = UIImage(named: fitClass.category)
        
        if registrants.contains(uid) {
            btnSignUpCancel.setTitle("<<< Cancel registration", for: .normal)
            registered = true
        } else {
            btnSignUpCancel.setTitle("SIGN UP >>>", for: .normal)
            registered = false
        }
    }
}
