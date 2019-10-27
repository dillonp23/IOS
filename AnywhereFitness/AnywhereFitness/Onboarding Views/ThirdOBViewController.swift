//
//  ThirdOBViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class ThirdOBViewController: UIViewController {
    
    @IBOutlet weak var cancelBtnImage: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cancelBtnImage.pulsate()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func getStartedTapped(_ sender: Any) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "AppHomeStoryboard")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
    }
    
}
