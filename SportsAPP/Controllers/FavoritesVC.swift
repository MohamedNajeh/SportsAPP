//
//  FavoritesVC.swift
//  SportsAPP
//
//  Created by Najeh on 28/02/2022.
//

import UIKit
import SafariServices
import CoreData
import Lottie
import Kingfisher
class FavoritesVC: UIViewController {

    var leagues:[Leagues] = []
    var coreDataLeagues:[NSManagedObject] = []
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    var animationView:AnimationView?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "LeageFavCell", bundle: nil), forCellReuseIdentifier: "Cell")
      //  fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData()
    {
        context = appDelegate.persistentContainer.viewContext
        print("Fetching Data..")
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavModel")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            coreDataLeagues = result as! [NSManagedObject]
            self.tableView.reloadData()
            
        } catch {
            print("Fetching data Failed")
       }
    }
    
}
extension FavoritesVC:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coreDataLeagues.count == 0 {
            animationView = .init(name: "empty")
            animationView?.frame = view.bounds
            view.addSubview(animationView!)
            animationView?.animationSpeed = 0.75
            animationView?.loopMode = .loop
            animationView?.play()
        }
        if coreDataLeagues.count > 0{
            animationView?.removeFromSuperview()
        }
        return coreDataLeagues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LeageFavCell
        
        cell.leageNameLbl.text = coreDataLeagues[indexPath.row].value(forKey: "leagueName") as? String
        cell.imgV.kf.indicatorType = .activity
        cell.imgV.kf.setImage(with: URL(string: coreDataLeagues[indexPath.row].value(forKey: "imgPath") as? String ?? " "), placeholder:UIImage(named: "back-1.img"), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
//       // cell.setIndex(index: indexPath.row)
        cell.btnOutlet.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "LDSegue", sender: indexPath)
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailsVC") as! DetailsVC
       
        vc.league?.idLeague = coreDataLeagues[indexPath.row].value(forKey: "idLeague") as! String
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
    
            tableView.beginUpdates()
            let alert = UIAlertController(title: "Delete from favourites", message: "Are you sure you want to delete this item from favorites", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                tableView.deleteRows(at:[indexPath], with: .automatic)
                self.context.delete(self.coreDataLeagues[indexPath.row])
                self.coreDataLeagues.remove(at: indexPath.row)
                self.appDelegate.saveContext()

                
                tableView.endUpdates()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(alert, animated: true, completion: nil)
            
        }
    }
    
    
}

extension FavoritesVC:LeageCellDelegate {
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

