//
//  sportsCell.swift
//  SportsAPP
//
//  Created by Najeh on 01/03/2022.
//

import UIKit

class sportsCell: UICollectionViewCell {
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgV: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 1
        contentView.layer.masksToBounds = true
        contentView.layer.borderColor = UIColor.black.cgColor
        imgV.layer.cornerRadius = 25
    }
    
}
