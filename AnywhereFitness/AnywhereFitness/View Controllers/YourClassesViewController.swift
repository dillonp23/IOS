//
//  YourClassesViewController.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class YourClassesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var numberOfClassesLabel: UILabel!
    @IBOutlet weak var addClassBtn: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var registeredClasses: [FitClassRepresentation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewForUserType()
        getClasses()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getClasses()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setUpViewForUserType() {
        guard let user = UserController.shared.loggedInUser else { return }
        
        if user.userType == "client" {
            addClassBtn.isHidden = true
            subtitleLabel.text = "View your upcoming schedule\n and cancel if needed"
        } else {
            addClassBtn.isHidden = false
            subtitleLabel.text = "View your upcoming schedule\n and add or cancel classes"
        }
    }
    
    func getClasses() {
        let fitClassController = FitClassController.shared
        fitClassController.fetchClassesFromServer { (_) in
            
            guard let user = UserController.shared.loggedInUser else { return }
            self.registeredClasses = []
            self.registeredClasses = fitClassController.classRepsFor(client: user)
            
            DispatchQueue.main.async {
                self.updateViews()
                self.collectionView.reloadData()
            }
        }
    }
    
    func updateViews() {
        let numberOfClasses = registeredClasses.count
        numberOfClassesLabel.text = "You currently have \(numberOfClasses) reservation(s)"
    }

}

extension YourClassesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return registeredClasses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourClassesCell", for: indexPath) as? YourClassesCollectionViewCell else { return UICollectionViewCell() }
        
        let fitClass = registeredClasses[indexPath.item]
        
        cell.titleLabel.text = fitClass.title
        cell.categoryLabel.text = "Class Type: \(fitClass.category)"
        cell.intensityLabel.text = "Intensity Level: \(fitClass.intensity.capitalized)"
        cell.locationLabel.text = "\(fitClass.city), \(fitClass.state)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, @ h a"
        if let timeSince1970 = Double(fitClass.startTime) {
            let date = Date(timeIntervalSince1970: timeSince1970)
            cell.timeAndDurationLabel.text = dateFormatter.string(from: date) + " for \(fitClass.duration) minutes"
        }
        
        cell.fitClass = fitClass
        cell.delegate = self
        cell.fitClassController = FitClassController.shared
        
        cell.fitnessCategoryImage.image = UIImage(named: fitClass.category)
        
        return cell
    }
    
    
}
