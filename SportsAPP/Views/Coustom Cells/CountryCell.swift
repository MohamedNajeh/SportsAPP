//
//  CountryCell.swift
//  SportsAPP
//
//  Created by Najeh on 02/03/2022.
//

import UIKit

class CountryCell: UICollectionViewCell {

    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var containerView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 25
        containerView.layer.masksToBounds = true 
        // Initialization code
    }

}
