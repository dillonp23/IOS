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
    var startTime = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let title = txtClassTitle.text, !title.isEmpty,
            let duration = Int(txtDuration.text ?? "-1"), duration > 0,
            let addr1 = txtAddr1.text, !addr1.isEmpty,
            let city = txtCity.text, !city.isEmpty,
            let state = txtState.text, !state.isEmpty,
            let zip = txtZip.text, !zip.isEmpty,
            let price = Double(txtPrice.text ?? "-1"), price > 0,
            let capacity = Int(txtCapacity.text ?? "0"), capacity >= 0
        else { return }
        
    }
    

}
