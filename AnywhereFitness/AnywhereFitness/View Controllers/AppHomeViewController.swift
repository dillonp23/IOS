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
    
    var fitClassRepsForUserMetro: [FitClassRepresentation] = []
    
    
    private func checkLoggedInUserStatus() {
        //checking for current user
        //if no current user present welcome navigation controlller
        
        UserController.shared.checkPreviousSignIn() { _ in
            if UserController.shared.loggedInUser == nil {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "UserAuth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "UserAuthStoryboard")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLoggedInUserStatus()
        FitClassController.shared.fetchClassesFromServer { (_) in
            
            if let user = UserController.shared.loggedInUser, let metro = user.metro {
                let fitClass = FitClassController.shared
                self.fitClassRepsForUserMetro = fitClass.classRepsFor(metro: metro)
            }
            
            DispatchQueue.main.async {
                self.updateViews()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FitClassController.shared.fetchClassesFromServer { (_) in
            
            if let user = UserController.shared.loggedInUser, let metro = user.metro {
                let fitClass = FitClassController.shared
                self.fitClassRepsForUserMetro = fitClass.classRepsFor(metro: metro)
            }
            
            DispatchQueue.main.async {
                self.updateViews()
                self.collectionView.reloadData()
            }
        }
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        guard let searchVC = segue.destination as? SearchViewController else { return }
        if let searchString = searchTextField.text, !searchString.isEmpty {
            searchVC.searchTerm = searchString
            searchVC.fitClassController = FitClassController.shared
        } else {
            searchVC.fitClassController = FitClassController.shared
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
//        return fitClassController.fitClassRepresentations.count
        return fitClassRepsForUserMetro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fitnessClassCell", for: indexPath) as? FitnessClassCollectionViewCell else { return UICollectionViewCell() }
        
//        let fitClass = fitClassController.fitClassRepresentations[indexPath.item]
        let fitClass = fitClassRepsForUserMetro[indexPath.item]
        
        cell.fitClassController = FitClassController.shared
        cell.fitClass = fitClass
        cell.delegate = self
        
        return cell
    }
    
    
}
