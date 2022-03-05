//
//  DetailsVC.swift
//  SportsAPP
//
//  Created by Najeh on 27/02/2022.
//

import UIKit
import Alamofire
import CoreData
import Lottie
import Reachability
class DetailsVC: UIViewController {

    var events:[Events] = []
    var teams:[Teams] = []
    var round:Int = 26
    var league:Leagues?
    var isLiked:Bool = false
    let likedImag = UIImage(named: "filldHeart")
    let unlikedImag = UIImage(named: "emptyHeart")
    var animationView:AnimationView?
    var coreDataLeagues:[NSManagedObject] = []
    //var leageID:String?,imgPath:String?,leageName:String?,youtubePath:String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    var context:NSManagedObjectContext!
    let reachability = try! Reachability()
    let defaults = UserDefaults.standard
    @IBOutlet weak var favBtnOutlet: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(league?.idLeague ?? "4647")
        context = appDelegate.persistentContainer.viewContext
        isLiked = defaults.bool(forKey: league?.idLeague ?? "-")
        if isLiked{
            favBtnOutlet.setImage(likedImag, for: .normal)
        }
        collectionView.collectionViewLayout = creatCompositionalLayout()
        collectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: "header", withReuseIdentifier: "HeaderView")
        collectionView.register(UINib(nibName: "LatestCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        collectionView.register(UINib(nibName: "TeamsCell", bundle: nil), forCellWithReuseIdentifier: "teamCell")
        fetchUpComing()
        fetchTeams()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkReachability()
    }
    
    func flipLikedStatus(){
        isLiked = !isLiked
        if isLiked {
            favBtnOutlet.setImage(likedImag, for: .normal)
        }
        else{
            favBtnOutlet.setImage(unlikedImag, for: .normal)
        }
    }
    func openDatabse()
        {
            let entity = NSEntityDescription.entity(forEntityName: "FavModel", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            saveData(UserDBObj:newUser)
        }

        func saveData(UserDBObj:NSManagedObject)
        {
           // print(league?.strYoutube)
            UserDBObj.setValue(league?.strBadge, forKey: "imgPath")
            UserDBObj.setValue(league?.idLeague, forKey: "leagueId")
            UserDBObj.setValue(league?.strLeague, forKey: "leagueName")
            UserDBObj.setValue(league?.strYoutube, forKey: "youtubePath")
            print("Storing Data..")
            do {
                try context.save()
            } catch {
                print("Storing data Failed")
            }

            //fetchData()
        }
    
    func deleteSingleFromCore(){
        let id = league?.idLeague
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "FavModel")
        request.predicate = NSPredicate(format:"leagueId = %@", id!)
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for object in result {
                context.delete(object as! NSManagedObject)
            }
        } catch {
            print("Fetching data Failed")
       }
       
    }
    
    func fetchUpComing(){
        NetworkManager.shared.fetchData(url: "https://www.thesportsdb.com/api/v1/json/2/eventsround.php?id=\(league?.idLeague ?? "4647")&r=\(round)", decodable: EventNetworkController.self) { [weak self] result in
            switch result{
            case .success(let events):
                if events.events == nil {
                    return
                }
                self?.events = events.events!
                DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    func checkReachability() {
        reachability.whenReachable = {reachability in
            if reachability.connection == .wifi{
                print("Via Wifi")
            }else{
                print("Via calluler")
               // self.isOnline = true
            }
        }
        reachability.whenUnreachable = {_ in
            print("No connection")
            //self.isOnline = false
            let alert = UIAlertController(title: "NO Connection⛔️", message: "Check your Connection😃", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        
        do{
            try reachability.startNotifier()
        }catch{
            print("Unable to notify")
        }
    }
    
    func fetchTeams(){
        let name1 = league?.strLeague
        let name = name1?.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        NetworkManager.shared.fetchData(url: "https://www.thesportsdb.com/api/v1/json/2/search_all_teams.php?l=\(name ?? "Egypt")", decodable: teamsController.self) { [weak self] result in
            switch result{
            case .success(let teams):
                if teams.teams == nil{
                    return
                }
                self?.teams = teams.teams!
                DispatchQueue.main.async {
                self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func favBtnPressed(_ sender: Any) {
        if !isLiked{
        defaults.set(true, forKey: league?.idLeague ?? "1")
        openDatabse()
        flipLikedStatus()
        animationView = .init(name: "like")
        animationView?.frame = view.bounds
        view.addSubview(animationView!)
        animationView?.animationSpeed = 0.25
        animationView?.play()
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
            self.animationView?.removeFromSuperview()
        }
        }else{
            flipLikedStatus()
            defaults.set(false, forKey: league?.idLeague ?? "1")
            deleteSingleFromCore()
        }
    }
    func creatCompositionalLayout() -> UICollectionViewCompositionalLayout{
        let layout = UICollectionViewCompositionalLayout { [weak self] (index, enviroment) -> NSCollectionLayoutSection? in
            self?.creatSectionFor(index: index, enviroment: enviroment)
        }
        return layout
    }
    
    func creatSectionFor(index: Int , enviroment:NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection{
        
        switch index {
        case 0:
            return creatFirstSection()
        case 1:
            return creatSecondSection()
        case 2:
            return creatThirdSection()
        default:
            return creatFirstSection()
        }
    }
    
    
    func creatFirstSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        //Configure Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        //supplemantary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func creatSecondSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        //Configure Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        //section
        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .continuous
        
        //supplemantary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }
    
    func creatThirdSection() -> NSCollectionLayoutSection {
        //smallItems
        let smallItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let samllItem = NSCollectionLayoutItem(layoutSize: smallItemSize)
        samllItem.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        
        let largeItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let largeItem = NSCollectionLayoutItem(layoutSize: largeItemSize)
        largeItem.contentInsets = NSDirectionalEdgeInsets(top: 2.5, leading: 2.5, bottom: 2.5, trailing: 2.5)
        //Configure Groups
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [samllItem])
        
        let horizantilGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.4))
        let horizantilGroup = NSCollectionLayoutGroup.horizontal(layoutSize: horizantilGroupSize, subitems: [verticalGroup ,verticalGroup])
        //section
        let section = NSCollectionLayoutSection(group: horizantilGroup)
        section.orthogonalScrollingBehavior = .groupPaging
        
        //supplemantary
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "header", alignment: .top)
        section.boundarySupplementaryItems = [header]
        return section
    }


    


}

extension DetailsVC:UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 2 ? teams.count : events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        switch indexPath.section{
        case 0:
            let cell1 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! UpComingCell
            cell1.firstClub.text = events[indexPath.row].strEvent
            //cell1.secondClub.text = events[indexPath.row].strAwayTeam
            cell1.dateLbl.text = events[indexPath.row].dateEvent
            cell1.eventImg.kf.setImage(with: URL(string: events[indexPath.row].strThumb!), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            return cell1
        case 1:
            var res = "2 - 2"
            if events[indexPath.row].intHomeScore != nil{
                res=events[indexPath.row].intHomeScore!+"-"+events[indexPath.row].intAwayScore!
            }
            let latestCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LatestCell
            latestCell.imgV.kf.setImage(with: URL(string: events[indexPath.row].strThumb!), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            latestCell.resultLbl.text = res
            return latestCell
            
        case 2:
            let teamsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "teamCell", for: indexPath) as! TeamsCell
            teamsCell.imgV.kf.indicatorType = .activity
            teamsCell.imgV.kf.setImage(with: URL(string: teams[indexPath.row].strTeamBadge ?? " "), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
            return teamsCell
        default:
            print("NoThing")
//            cell.backgroundColor = UIColor(hue: CGFloat(drand48()), saturation: 1, brightness: 1, alpha: 1)
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "teamDetails") as! TeamDetailsVC
        vc.logoPath = teams[indexPath.row].strTeamBadge!
        vc.stadiumPath = teams[indexPath.row].strStadiumThumb!
        vc.name = teams[indexPath.row].strTeam!
        vc.descrip = teams[indexPath.row].strAlternate!
        vc.capacity = teams[indexPath.row].intStadiumCapacity!
        vc.address = teams[indexPath.row].strStadiumLocation!
        vc.face = teams[indexPath.row].strFacebook!
        vc.insta = teams[indexPath.row].strInstagram!
        vc.twitter = teams[indexPath.row].strTwitter!
        vc.web = teams[indexPath.row].strWebsite!
        
        
      //  self.navigationController?.pushViewController(vc, animated: true)
        self.present(vc, animated: true) {
            //self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: "header", withReuseIdentifier: "HeaderView", for: indexPath) as? HeaderView else{
            return UICollectionReusableView()
        }
        switch indexPath.section{
        case 0:
            view.title = "UpComing"
        case 1:
            view.title = "Latest"
        case 2:
            view.title = "Teams"
        default:
            print("NO Thing")
        }
        //view.title = indexPath.section == 1 ? "Latest Result" : "Teams"
        return view
    }
    



}
