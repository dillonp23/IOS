//
//  UserAuthViewController.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/22/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var segSignUpIn: UISegmentedControl!
    @IBOutlet weak var stackSignIn: UIStackView!
    @IBOutlet weak var stackSignUp: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var switchInstructor: UISwitch!
    @IBOutlet weak var btnSignUpIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segSignUpIn.translatesAutoresizingMaskIntoConstraints = false
        stackSignIn.translatesAutoresizingMaskIntoConstraints = false
        stackSignUp.translatesAutoresizingMaskIntoConstraints = false
        txtEmail.translatesAutoresizingMaskIntoConstraints = false
        txtPassword.translatesAutoresizingMaskIntoConstraints = false
        txtConfirmPassword.translatesAutoresizingMaskIntoConstraints = false
        txtFirstName.translatesAutoresizingMaskIntoConstraints = false
        txtLastName.translatesAutoresizingMaskIntoConstraints = false
        switchInstructor.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [segSignUpIn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                           segSignUpIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           segSignUpIn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
                           stackSignIn.topAnchor.constraint(equalTo: segSignUpIn.bottomAnchor, constant: 20),
                           stackSignIn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           stackSignIn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
                           stackSignUp.topAnchor.constraint(equalTo: stackSignIn.bottomAnchor, constant: 10),
                           stackSignUp.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                           stackSignUp.widthAnchor.constraint(equalTo: stackSignIn.widthAnchor),
                           btnSignUpIn.topAnchor.constraint(equalTo: stackSignUp.bottomAnchor, constant: 20),
                           btnSignUpIn.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    

    private func updateViews() {
        if segSignUpIn.selectedSegmentIndex == 0 {
            stackSignUp.isHidden = false
            btnSignUpIn.setTitle("Sign Up", for: .normal)
        } else {
            stackSignUp.isHidden = true
            btnSignUpIn.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpInChanged(_ sender: Any) {
        updateViews()
    }
    
    

}
