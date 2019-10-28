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
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var searchTerm: String?
    var fitClassController: FitClassController?
    var searchResults: [FitClassRepresentation] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        getResults()
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
        getResults()
    }
    

    func updateViews() {
        if let searchTerm = searchTerm {
            searchClassesTextField.text = searchTerm
        }
    }
    
    func getResults() {
        if let searchTerm = searchClassesTextField.text, !searchTerm.isEmpty {
            guard let metro = UserController.shared.loggedInUser?.metro, let fitClassController = fitClassController else { return }
            searchResults.removeAll()
            searchResults = fitClassController.classRepsFor(category: searchTerm, metro: metro)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        } else {
            guard let fitClassController = fitClassController else { return }
            searchResults.removeAll()
            searchResults = fitClassController.fitClassRepresentations
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResults.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "classSearchCell", for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
            
            let fitClass = searchResults[indexPath.item]
            
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
