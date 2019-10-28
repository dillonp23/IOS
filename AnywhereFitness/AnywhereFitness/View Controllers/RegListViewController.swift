//
//  RegListViewController.swift
//  AnywhereFitness
//
//  Created by Joel Groomer on 10/28/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class RegListViewController: UIViewController {
    @IBOutlet weak var lblClassTitle: UILabel!
    @IBOutlet weak var lblDateAndTime: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
//    var fitClassController: FitClassController?
    var fitClass: FitClassRepresentation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        updateViews()
    }
    
    func updateViews() {
        guard let fitClass = fitClass else { return }
        lblClassTitle.text = fitClass.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, @ h a"
        if let timeSince1970 = Double(fitClass.startTime) {
            let date = Date(timeIntervalSince1970: timeSince1970)
            self.lblDateAndTime.text = dateFormatter.string(from: date) + " for \(fitClass.duration) minutes"
        }
    }
}

extension RegListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fitClass = fitClass else { return 0 }
        return fitClass.registrants?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let fitClass = fitClass,
            let cell = tableView.dequeueReusableCell(withIdentifier: "registrantCell")
        else { return UITableViewCell() }
        
        cell.textLabel?.text = fitClass.registrants?[indexPath.row]
        return cell
    }
}
