//
//  YourClassesCollectionViewCell.swift
//  AnywhereFitness
//
//  Created by Dillon P on 10/27/19.
//  Copyright © 2019 Julltron. All rights reserved.
//

import UIKit

class YourClassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var fitnessCategoryImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeAndDurationLabel: UILabel!
    
    @IBAction func cancelBtnTapped(_ sender: Any) {
    }
    
}
