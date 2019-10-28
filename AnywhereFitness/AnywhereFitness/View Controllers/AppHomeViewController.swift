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
        fitClassController.fetchClassesFromServer { (_) in
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.updateViews()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.updateViews()
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
            searchVC.fitClassController = fitClassController
        } else {
            searchVC.fitClassController = fitClassController
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
        return fitClassController.fitClassRepsForUserMetro.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fitnessClassCell", for: indexPath) as? FitnessClassCollectionViewCell else { return UICollectionViewCell() }
        
//        let fitClass = fitClassController.fitClassRepresentations[indexPath.item]
        let fitClass = fitClassController.fitClassRepsForUserMetro[indexPath.item]
        
        cell.fitClassController = fitClassController
        cell.fitClass = fitClass
        cell.delegate = self
        
        return cell
    }
    
    
}
