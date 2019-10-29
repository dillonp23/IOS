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
    
    var fitClassController = FitClassController.shared
//    var categoryController = CategoryController()
    var categories = ["Cardio", "CrossFit", "HIIT", "Pilates", "Yoga"]
    var startTime: String?
    var category = ""
    var intensity = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pkrCategoryIntensity.delegate = self
        pkrCategoryIntensity.dataSource = self
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let uid = UserController.shared.loggedInUser?.uid,
            let metro = UserController.shared.loggedInUser?.metro,
            let title = txtClassTitle.text, !title.isEmpty,
            let startTime = startTime,
            let durationString = txtDuration.text, !durationString.isEmpty,
            let duration = Int(durationString), duration > 0,
            let addr1 = txtAddr1.text, !addr1.isEmpty,
            let city = txtCity.text, !city.isEmpty,
            let state = txtState.text, !state.isEmpty,
            let zip = txtZip.text, !zip.isEmpty,
            let price = Double(txtPrice.text ?? "-1"), price > 0
        else { return }
        
        let addr2 = txtAddr2.text
        var capacity: Int?
        if let capacityString = txtCapacity.text {
            capacity = Int(capacityString)
        }
                
        let fitClass = FitClassRepresentation(classID: UUID().uuidString, instructor: uid, startTime: startTime, duration: duration, title: title, category: category, intensity: intensity, metro: metro, addr1: addr1, addr2: addr2, city: city, state: state, zip: zip, price: price, maxRegistrants: capacity)
        
        fitClassController.createOrUpdateFitClass(with: fitClass) { created in
            if created {
                self.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "We're sorry, an error occurred and we weren't able to save your class. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            }
        }
    }
    
    @IBAction func startTimeUpdated(_ sender: UIDatePicker) {
        startTime = String(sender.date.timeIntervalSince1970)
    }
}

extension AddClassViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 1 {
//            return categoryController.allCategories.count
            return categories.count
        } else {
            return 3
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
//            return categoryController.allCategoriesAsStrings[row]
            return categories[row]
        }
        var intensity: String
        switch row {
        case 0:
            intensity = "light"
        case 1:
            intensity = "medium"
        default:
            intensity = "intense"
        }
        return intensity
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
//            category = categoryController.allCategoriesAsStrings[row]
            category = categories[row]
        } else {
            var intensity: String
            switch row {
            case 0:
                intensity = "light"
            case 1:
                intensity = "medium"
            default:
                intensity = "intense"
            }
            self.intensity = intensity
        }
    }
}
