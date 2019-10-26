//
//  AppHomeViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/21/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class AppHomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    var fitClassController = FitClassController()
    
    private func checkLoggedInUserStatus() {
        //checking for current user
        //if no current user present welcome navigation controlller
        if UserController.shared.loggedInUser == nil {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "UserAuth", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UserAuthStoryboard")
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        checkLoggedInUserStatus()
        fitClassController.fetchClassesFromServer { (_) in
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateViews()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let searchVC = segue.destination as? SearchViewController else { return }
        if let searchString = searchTextField.text, !searchString.isEmpty {
            searchVC.searchTerm = searchString
//            searchVC.fitClassController = fitClassController
        }
    }
    
    func updateViews() {
        if UserController.shared.loggedInUser != nil {
            greetingLabel.text = "Hi, \(UserController.shared.loggedInUser?.firstName ?? "")!"
        } else {
            greetingLabel.text = "Welcome"
        }
    }

}

extension AppHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fitClassController.fitClassRepresentations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fitnessClassCell", for: indexPath) as? FitnessClassCollectionViewCell else { return UICollectionViewCell() }
        
        let fitClass = fitClassController.fitClassRepresentations[indexPath.item]
        
        cell.titleLabel.text = fitClass.title
        cell.categoryLabel.text = "Class Type: \(fitClass.category)"
        cell.intensityLabel.text = "Intensity Level: \(fitClass.intensity.capitalized)"
        cell.locationLabel.text = "\(fitClass.city), \(fitClass.state)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, @ h a"
        if let timeSince1970 = Double(fitClass.startTime) {
            let date = Date(timeIntervalSince1970: timeSince1970)
            cell.timeAndDurationLabel.text = dateFormatter.string(from: date) + " for \(fitClass.duration) minutes"
        }
        
        cell.fitnessCategoryImage.image = UIImage(named: fitClass.category)
        
        return cell
    }
    
    
}
