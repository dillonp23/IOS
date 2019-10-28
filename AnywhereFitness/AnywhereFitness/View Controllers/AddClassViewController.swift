//
//  AddClassViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class AddClassViewController: UIViewController {

    @IBOutlet weak var txtClassTitle: UITextField!
    @IBOutlet weak var pkrStartTime: UIDatePicker!
    @IBOutlet weak var txtDuration: UITextField!
    @IBOutlet weak var pkrCategoryIntensity: UIPickerView!
    @IBOutlet weak var txtAddr1: UITextField!
    @IBOutlet weak var txtAddr2: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    @IBOutlet weak var txtState: UITextField!
    @IBOutlet weak var txtZip: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtCapacity: UITextField!
    
    var fitClassController: FitClassController?
    var startTime: String?
    var category = ""
    var intensity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let fitClassController = fitClassController,
            let uid = UserController.shared.loggedInUser?.uid,
            let metro = UserController.shared.loggedInUser?.metro,
            let title = txtClassTitle.text, !title.isEmpty,
            let startTime = startTime,
            let duration = Int(txtDuration.text ?? "-1"), duration > 0,
            let addr1 = txtAddr1.text, !addr1.isEmpty,
            let city = txtCity.text, !city.isEmpty,
            let state = txtState.text, !state.isEmpty,
            let zip = txtZip.text, !zip.isEmpty,
            let price = Double(txtPrice.text ?? "-1"), price > 0
        else { return }
        
        let addr2 = txtAddr2.text ?? ""
        var capacity: Int?
        if let capacityString = txtCapacity.text {
            capacity = Int(capacityString)
        }
        
        let fitClass = FitClass(classID: UUID().uuidString, instructor: uid, startTime: startTime, duration: duration, title: title, category: category, intensity: intensity, metro: metro, addr1: addr1, addr2: addr2, city: city, state: state, zip: zip, price: price, maxRegistrants: capacity)
        
        fitClassController.createOrUpdateFitClass(with: fitClass.representation) { created in
            if created {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "We're sorry, an error occurred and we weren't able to save your class. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }
    }
    
    

}
