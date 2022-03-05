//
//  UpComingCell.swift
//  SportsAPP
//
//  Created by Najeh on 24/02/2022.
//

import UIKit

class UpComingCell: UICollectionViewCell {
    @IBOutlet weak var eventImg: UIImageView!
    @IBOutlet weak var firstClub: UILabel!
    @IBOutlet weak var secondClub: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 25
        self.eventImg.layer.cornerRadius = 20
    }
    
}
