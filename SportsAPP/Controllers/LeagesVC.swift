//
//  LeagesVC.swift
//  SportsAPP
//
//  Created by Najeh on 22/02/2022.
//

import UIKit
import Alamofire
import SafariServices
import Reachability
import Kingfisher
class LeagesVC: UIViewController {


    var country:String = "England"
    var sortType:String = "Soccer"
    var leagues:[Leagues] = []
    var selectedLeague:Leagues?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "LeageFavCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        loadAllLeagues()
        view.backgroundColor = .systemBackground

    }
    
    
    func loadAllLeagues(){
        NetworkManager.shared.fetchData(url: "https://www.thesportsdb.com/api/v1/json/2/search_all_leagues.php?c=\(country)&s=\(sortType)", decodable: LeagueRoot.self) { result in
            switch result{
            case .success(let leagues):
                if leagues.countrys == nil {
                    return 
                }
                self.leagues = leagues.countrys!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
}

extension LeagesVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeageFavCell
        
        cell.leageNameLbl.text = leagues[indexPath.row].strLeague
        cell.imgV.kf.indicatorType = .activity
        cell.imgV.kf.setImage(with: URL(string: leagues[indexPath.row].strBadge!), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
       // cell.setIndex(index: indexPath.row)
        cell.btnOutlet.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
//
//        vc.league = leagues[indexPath.row]
//        self.present(vc, animated: true, completion: nil)
//        self.navigationController?.pushViewController(vc, animated: true)
        
        selectedLeague = leagues[indexPath.row]
        self.performSegue(withIdentifier: "LDSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LDSegue" {
            let dest = segue.destination as! DetailsVC
            dest.league = selectedLeague
            dest.title = "Details"
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    
}

extension LeagesVC:LeageCellDelegate {
    func didTappedBtn(with tag: Int) {
        guard let url = URL(string: "https://"+leagues[tag].strYoutube!) else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
        print(leagues[tag].strYoutube!)
        print(url)
    }
}
