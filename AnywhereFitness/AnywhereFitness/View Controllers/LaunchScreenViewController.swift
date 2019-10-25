//
//  LaunchScreenViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/25/19.
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
        }
    }
//        } else {
//            DispatchQueue.main.async {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "AppHomeStoryboard")
//            self.present(vc, animated: false, completion: nil)
//        }
//    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // splashscreen for delay of 2, then goes to home
        checkLoggedInUserStatus()
        perform(#selector(LaunchScreenViewController.showHomePage), with: nil, afterDelay: 2)
    }
    
    
    // go to home screen of app
    @objc func showHomePage(){
        // after delay shows home
        performSegue(withIdentifier: "showHomePageSegue", sender: self)
    }

}
