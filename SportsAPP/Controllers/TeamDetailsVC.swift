//
//  TeamDetailsVC.swift
//  SportsAPP
//
//  Created by Najeh on 01/03/2022.
//

import UIKit
import SafariServices
import Kingfisher
class TeamDetailsVC: UIViewController {

    @IBOutlet weak var logoImgV: UIImageView!
    @IBOutlet weak var nameLblOutlet: UILabel!
    @IBOutlet weak var descriptionLblOutlet: UILabel!
    
    @IBOutlet weak var tadiumContainerView: UIView!
    
    @IBOutlet weak var stadiumImgV: UIImageView!
    
    @IBOutlet weak var stadiumAdressLbl: UILabel!
    
    @IBOutlet weak var stadiumCapacityLbl: UILabel!
    
    var logoPath = "",name = "",descrip = "",stadiumPath = "",address = "",capacity = ""
    var face = "" , insta = "" , twitter = "", web = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        logoImgV.kf.setImage(with: URL(string: logoPath), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        
        stadiumImgV.kf.setImage(with: URL(string: stadiumPath), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        
        nameLblOutlet.text = name
        descriptionLblOutlet.text = descrip
        stadiumAdressLbl.text = address
        stadiumCapacityLbl.text = "Capacity of "+capacity
        // Do any additional setup after loading the view.
    }
    

    @IBAction func facebookBtnPressed(_ sender: Any) {
        guard let url = URL(string: "https://"+face) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    @IBAction func instaBtnPressed(_ sender: Any) {
        guard let url = URL(string: "https://"+insta) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    @IBAction func twitterBtnpressed(_ sender: Any) {
        guard let url = URL(string: "https://"+twitter) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    @IBAction func webSiteBtnPressed(_ sender: Any) {
        guard let url = URL(string: "https://"+web) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
}
