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
    @IBOutlet weak var userTypeStackView: UIStackView!
    @IBOutlet weak var userTypeSwitch: UISwitch!
    
    
    var registeredClasses: [FitClassRepresentation] = []
    var hostedClasses: [FitClassRepresentation] = []
    
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
    
    @IBAction func toggleUserType(_ sender: UISwitch) {
        setUpViewForUserType()
        getClasses()
    }
    
    
    func setUpViewForUserType() {
        guard let user = UserController.shared.loggedInUser else { return }
        
        if user.userType == "client" {
            userTypeStackView.isHidden = true
            addClassBtn.isHidden = true
            subtitleLabel.text = "View your upcoming schedule\n and cancel if needed"
        } else {
            userTypeStackView.isHidden = false
            if userTypeSwitch.isOn == false {
                addClassBtn.isHidden = true
                subtitleLabel.text = "View your upcoming schedule\n and cancel if needed"
            } else if userTypeSwitch.isOn == true {
                addClassBtn.isHidden = false
                subtitleLabel.text = "See classes you'll be hosting\n and add or cancel a class"
            }
        }
    }
    
    func getClasses() {
        let fitClassController = FitClassController.shared
        
        if userTypeSwitch.isOn == false {
            fitClassController.fetchClassesFromServer { (_) in
                
                guard let user = UserController.shared.loggedInUser else { return }
                self.registeredClasses = []
                self.registeredClasses = fitClassController.classRepsFor(client: user)
                
                DispatchQueue.main.async {
                    self.updateViews()
                    self.collectionView.reloadData()
                }
            }
        } else {
            
            fitClassController.fetchClassesFromServer { (_) in
                
                guard let user = UserController.shared.loggedInUser else { return }
                self.hostedClasses = []
                self.hostedClasses = fitClassController.classRepsFor(instructor: user)
                
                DispatchQueue.main.async {
                    self.updateViews()
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func updateViews() {
        if userTypeSwitch.isOn == false {
            let numberOfClasses = registeredClasses.count
            numberOfClassesLabel.text = "You currently have \(numberOfClasses) reservation(s)"
        } else {
            let numberOfClasses = hostedClasses.count
            numberOfClassesLabel.text = "You'll be hosting \(numberOfClasses) class(es)"
        }
        
    }
    
}

extension YourClassesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems = 0
        if userTypeSwitch.isOn == false {
            numberOfItems = registeredClasses.count
        } else {
            numberOfItems = hostedClasses.count
        }
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YourClassesCell", for: indexPath) as? YourClassesCollectionViewCell else { return UICollectionViewCell() }
        
        if userTypeSwitch.isOn == false {
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
        } else {
            let fitClass = hostedClasses[indexPath.item]
            
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
        }
        
        return cell
        
        
    }
    
    
}
