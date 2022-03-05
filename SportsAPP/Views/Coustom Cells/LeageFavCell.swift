//
//  Leage&FavCell.swift
//  SportsAPP
//
//  Created by Najeh on 28/02/2022.
//

import UIKit
protocol LeageCellDelegate: AnyObject {
    func didTappedBtn(with tag: Int)
}
class LeageFavCell: UITableViewCell {

    weak var delegate:LeageCellDelegate?
    var index:Int?
    @IBOutlet weak var imgV: UIImageView!
    @IBOutlet weak var leageNameLbl: UILabel!
    @IBOutlet weak var btnOutlet: UIButton!
    @IBOutlet weak var backView: UIVisualEffectView!
    override func awakeFromNib() {
        super.awakeFromNib()
        btnOutlet.addTarget(self, action: #selector(connected(sender:)), for: .touchUpInside)
        
        backView.layer.cornerRadius = 25
        backView.layer.borderColor = UIColor.black.cgColor
        backView.layer.borderWidth = 1
        backView.layer.masksToBounds = true
        // Initialization code
    }
    @objc func connected(sender: UIButton){
        print(sender.tag)
        delegate?.didTappedBtn(with: sender.tag)
    }
    
    @IBAction func showYoutubeActionPressed(_ sender: Any) {
       // delegate?.didTappedBtn(with: index ?? 2)
    }
}
