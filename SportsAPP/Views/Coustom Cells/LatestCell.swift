//
//  LatestCell.swift
//  SportsAPP
//
//  Created by Najeh on 28/02/2022.
//

import UIKit

class LatestCell: UICollectionViewCell {

    @IBOutlet weak var backView: UIVisualEffectView!
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        imgV.layer.cornerRadius = 20
        backView.layer.cornerRadius = 20
        backView.layer.masksToBounds = true
        // Initialization code
    }

}
