//
//  YourClassesCollectionViewCell.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class YourClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fitnessCategoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeAndDurationLabel: UILabel!
    
    
    var fitClass: FitClassRepresentation? { didSet { updateViews() } }
    var fitClassController: FitClassController?
    var delegate: YourClassesViewController? //AppHomeViewController?
    var registered: Bool {
        guard let fitClass = fitClass,
            let registeredClients = fitClass.registrants,
            let user = UserController.shared.loggedInUser,
            let uid = user.uid,
            registeredClients.contains(uid)
        else { return false }
        
        return true
    }
    
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
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
                    }
        
                    DispatchQueue.main.async {
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
                        delegate.present(alert, animated: true, completion: nil)
                        delegate.getClasses()
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
                    }
                }
            }


