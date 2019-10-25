//
//  SearchViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/23/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchClassesTextField: UITextField!
    
    var searchTerm: String?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateViews()
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func searchButtonTapped(_ sender: Any) {
    }
    

    func updateViews() {
        if let searchTerm = searchTerm {
            searchClassesTextField.text = searchTerm
        }
    }
    
}
