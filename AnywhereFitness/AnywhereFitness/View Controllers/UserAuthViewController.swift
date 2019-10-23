//
//  UserAuthViewController.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/22/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit
import Firebase

class UserAuthViewController: UIViewController {
    
    @IBOutlet weak var segSignUpIn: UISegmentedControl!
    @IBOutlet weak var stackSignIn: UIStackView!
    @IBOutlet weak var stackSignUp: UIStackView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var pkrMetro: UIPickerView!
    @IBOutlet weak var switchInstructor: UISwitch!
    @IBOutlet weak var btnSignUpIn: UIButton!
    
    
    private let metros = ["Asheville", "Atlana", "Iowa City", "Los Angeles", "Philadelphia", "San Diego"]
    
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
        
        pkrMetro.dataSource = self
        
        btnSignUpIn.isEnabled = false
    }
    

    private func updateViews() {
        if segSignUpIn.selectedSegmentIndex == 0 { // Sign Up
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
    
    @IBAction func doAuth(_ sender: Any) {
        if segSignUpIn.selectedSegmentIndex == 0 {  // Sign Up
            guard let email = txtEmail.text, !email.isEmpty,
                let password = txtPassword.text, !password.isEmpty,
                let confirm = txtConfirmPassword.text, !confirm.isEmpty,
                let firstName = txtFirstName.text, !firstName.isEmpty,
                let lastName = txtLastName.text, !lastName.isEmpty
            else {
                    // should never get here bc button should be disabled
                    return
            }
            guard password == confirm else {
                print("A message about password mismatch should go here")
                return
            }
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("error creating user in Firebase: \(error)")
                    return
                }
                guard let authResult = authResult else {
                    print("No authResult")
                    return
                }
                print("User registered: \(authResult.user)")
                let userType = self.switchInstructor.isOn ? UserType.instructor : UserType.client
                let metro = self.metros[self.pkrMetro.selectedRow(inComponent: 0)]
                UserController.shared.createUser(uid: authResult.user.uid, firstName: firstName, lastName: lastName, email: email, userType: userType, metro: metro)
                UserController.shared.login()
            }
                
        } else {    // Sign In
            
        }
    }
    
}

extension UserAuthViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // TODO: - Improve UIPickerViewDataSource
    // This implementation should be updated to be dynamic
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return metros.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return metros[component]
    }
}

extension UserAuthViewController: UITextFieldDelegate {
    // TODO: - Add UITextFieldDelegate Methods
    // need to add methods to verify password, decide when to enable
    // the Sign Up/In button, deal with the keyboard, etc.
}
