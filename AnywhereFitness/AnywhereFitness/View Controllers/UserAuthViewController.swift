//
//  UserAuthViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/25/19.
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
        
        if let registerImage = UIImage(named: "registerBtn") {
            btnSignUpIn.setBackgroundImage(registerImage, for: .normal)
        }
    }
    
    
    private func updateViews() {
        if segSignUpIn.selectedSegmentIndex == 0 { // Sign Up
            stackSignUp.isHidden = false
            if let registerImage = UIImage(named: "registerBtn") {
                btnSignUpIn.setBackgroundImage(registerImage, for: .normal)
            }
        } else {
            stackSignUp.isHidden = true
            if let signInImage = UIImage(named: "signInBtn") {
                btnSignUpIn.setBackgroundImage(signInImage, for: .normal)
            }
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
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "UserAuth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "Onboarding1")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
            
        } else {    // Sign In
            guard let email = txtEmail.text, !email.isEmpty, let password = txtPassword.text, !password.isEmpty else {
                // should never get here bc button should be disabled
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    print("Error signing into Firebase: \(error)")
                    return
                }
                guard let authResult = authResult else {
                    print("No authResult")
                    return
                }
                print("User signed in: \(authResult.user)")
                UserController.shared.fetchOneUser(uid: authResult.user.uid) { (error) in
                    if let error = error {
                        print("User signed in but could not be fetched: \(error)")
                        return
                    }
                    UserController.shared.login()
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "AppHomeStoryboard")
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
}

extension UserAuthViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    // TODO: - Improve UIPickerViewDataSource
    // This implementation should be updated to be dynamic
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return metros.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return metros[row]
    }
    
}

extension UserAuthViewController: UITextFieldDelegate {
    // TODO: - Add UITextFieldDelegate Methods
    // need to add methods to verify password, decide when to enable
    // the Sign Up/In button, deal with the keyboard, etc.
}

