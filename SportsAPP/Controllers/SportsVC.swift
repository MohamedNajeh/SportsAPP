//
//  SportsVC.swift
//  SportsAPP
//
//  Created by Najeh on 21/02/2022.
//

import UIKit
import Alamofire
import Lottie
import Kingfisher
class SportsVC: UIViewController {


    var selectedCountry:String = "England"
    var spotrs:[Sports] = []
    var countries:[Countries] = []
    var lastActive:IndexPath = [1,0]
    var animationView:AnimationView?
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var contriesContainerView: UIView!
    @IBOutlet weak var contriesCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        loadAllSports()
        contriesContainerView.layer.cornerRadius = 25
        fetchCountries()
        contriesCollection.register(UINib(nibName: "CountryCell", bundle: nil), forCellWithReuseIdentifier: "CountryCell")
        backImg.layer.cornerRadius = 25
    }
    func loadAllSports(){
        NetworkManager.shared.fetchData(url: "https://www.thesportsdb.com/api/v1/json/2/all_sports.php", decodable: sportsController.self) { [weak self] result in
            switch result{
            case .success(let sports):
                    self?.spotrs = sports.sports!
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func nextBtnClicked(_ sender: Any) {
        animationView = .init(name: "done")
        animationView?.frame = view.bounds
        view.addSubview(animationView!)
        animationView?.animationSpeed = 0.75
        animationView?.loopMode = .loop
        animationView?.play()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { (timer) in
            self.animationView?.removeFromSuperview()
            self.contriesContainerView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
        }
        
    }
}

extension SportsVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == contriesCollection {
            return countries.count
        }
        return spotrs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == contriesCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CountryCell", for: indexPath) as! CountryCell
            cell.countryLbl.text = countries[indexPath.row].name_en
            
            return cell
        }
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as! sportsCell   
        item.nameLbl.text = spotrs[indexPath.row].strSport
        item.imgV.kf.indicatorType = .activity
        item.imgV.kf.setImage(with: URL(string: spotrs[indexPath.row].strSportThumb!), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        return item
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        if collectionView == contriesCollection {
            return CGSize(width: (collectionView.frame.width - 10), height: collectionView.frame.height/6)
        }
        return CGSize(width: (collectionView.frame.width - 10)/2, height: collectionView.frame.height/4)
       
    }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == contriesCollection{
            if self.lastActive != indexPath {
                let cell = collectionView.cellForItem(at: indexPath) as! CountryCell
                cell.countryLbl.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                cell.containerView.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                cell.containerView.layer.masksToBounds = true
                self.selectedCountry = countries[indexPath.row].name_en!
                print(self.selectedCountry)
                
                let cell1 = collectionView.cellForItem(at: self.lastActive) as? CountryCell
                cell1?.countryLbl.textColor = .black
                cell1?.containerView.backgroundColor = UIColor.clear
                cell1?.containerView.layer.masksToBounds = true
                self.lastActive = indexPath
            }
            
        }else{
        let vc:LeagesVC = self.storyboard?.instantiateViewController(withIdentifier: "LeagesVC") as! LeagesVC
        vc.title = "Leages"
        vc.sortType = spotrs[indexPath.row].strSport!
        vc.country = selectedCountry
        self.navigationController?.pushViewController(vc, animated: true)
        }
//present(UINavigationController(rootViewController: vc), animated: true)
    }
}

extension SportsVC{
    
    func fetchCountries(){
        NetworkManager.shared.fetchData(url: "https://www.thesportsdb.com/api/v1/json/2/all_countries.php", decodable: contriesController.self) { [weak self] result in
            switch result{
            case .success(let countries):
                self?.countries = countries.countries!
                DispatchQueue.main.async {
                    self?.contriesCollection.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}
