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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

}
