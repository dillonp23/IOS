//
//  SecondOBViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class SecondOBViewController: UIViewController {
    
    @IBOutlet weak var signUpImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UserAuth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Onboarding3")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .partialCurl
        self.present(vc, animated: true, completion: nil)
    }
    

}
