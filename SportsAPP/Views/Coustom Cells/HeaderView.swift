//
//  HeaderView.swift
//  SportsAPP
//
//  Created by Najeh on 22/02/2022.
//

import UIKit

class HeaderView: UICollectionReusableView {

    @IBOutlet weak var sectionHeader: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var title:String? {
        didSet{
            sectionHeader.text = title
        }
    }
    
}
