//
//  LaunchScreenViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/23/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit
import Firebase

class LaunchScreenViewController: UIViewController {

   private func checkLoggedInUserStatus() {
       //checking for current user
       //if no current user present welcome navigation controlller
        if UserController.shared.loggedInUser == nil {
           DispatchQueue.main.async {
               let storyboard = UIStoryboard(name: "UserAuth", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "UserAuthStoryboard")
               self.present(vc, animated: false, completion: nil)
           }
        } else {
            DispatchQueue.main.async {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "HomepageStoryboard")
                self.present(vc, animated: false, completion: nil)
            }
        }
   }
   
   override func viewDidLoad() {
       super.viewDidLoad()
       checkLoggedInUserStatus()
   }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        perform(#selector(LaunchScreenViewController.showmHomePage), with: nil, afterDelay: 1)
    }
   
   
   // go to home screen of app
   @objc func showmHomePage(){
       // after delay shows home
       performSegue(withIdentifier: "ShowHomePageSegue", sender: self)
   }

}
