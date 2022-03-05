//
//  TeamsCell.swift
//  SportsAPP
//
//  Created by Najeh on 28/02/2022.
//

import UIKit

class TeamsCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIVisualEffectView!
    @IBOutlet weak var imgV: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 25
        backView.layer.masksToBounds = true
        // Initialization code
    }

}
