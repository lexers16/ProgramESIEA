//
//  ViewController.swift
//  ProgrammationMoblile
//
//  Created by ALEXENDRE OBLI on 12/04/2019.
//  Copyright © 2019 Alexendre. All rights reserved.
//

import UIKit
import Alamofire
import CoreData


class ViewController: UIViewController {
    let cellIdentifier = "CellIdentifier"
    let link = "https://api.themoviedb.org/4/list/1?page=1&api_key=e2afa493459356483ae71ef32311be3b&language=fr-FR"
    var dict =  Dictionary<String , Any>()
    var dictionnary = NSDictionary()
    let background = UIImageView()
    var tmpDict : Dictionary<String,NSDictionary> = Dictionary<String,NSDictionary>()
    var seachBar : UISearchBar = UISearchBar()
    var tableSearch : UITableView = UITableView()
    var searchResults : [Dictionary<String,NSObject>] = [Dictionary<String,NSObject>]()


    var table : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        seachBar.delegate = self
        
        seachBar.frame = CGRect(x: self.view.safeAreaInsets.left, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.bounds.width, height: 40)
        seachBar.returnKeyType = .go
        tableSearch.frame = CGRect(x: self.view.safeAreaInsets.left, y: seachBar.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - seachBar.frame.maxY)
        tableSearch.alpha = 0
        tableSearch.register(UITableViewCell.self, forCellReuseIdentifier: "CellResult")
        
        tableSearch.dataSource = self
        tableSearch.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 10, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .vertical
        table = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
//        table.bottomAnchor =
        
        background.frame = CGRect(x: 0,y: 0,width: self.view.frame.width*5,height: self.view.frame.height)
        background.image = #imageLiteral(resourceName: "avengers-comic-con.jpg")
        self.view.addSubview(background)

        self.view.addSubview(table)
        table.dataSource = self
        table.delegate = self
//        table.rowHeight = 400
        table.backgroundColor = UIColor.clear
        table.register(Cells.self, forCellWithReuseIdentifier: "MyCell")
//        self.navigationController?.navigationBar.isHidden = true
        self.view.addSubview(seachBar)
        loadfromserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        self.background.frame.origin.x = 0
        UIView.animate(withDuration: 120, delay: 0, options: [.repeat,.curveEaseInOut,.autoreverse], animations: {
            self.background.frame.origin.x = -self.view.frame.width*4
        }, completion: nil)
    }
    
    
    func  loadData(searchedText : String) -> NSArray{
        let group = DispatchGroup() // initialize
        let List = NSArray()
        

        let lien = "https://api.themoviedb.org/3/search/movie?api_key=e2afa493459356483ae71ef32311be3b&language=fr-FR&query=\(searchedText)&page=1&include_adult=false"
        Alamofire.request(lien, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["results"] as! NSArray
                for key in valu{
                    let value = key as? NSDictionary
                    if !self.searchResults.contains(value as! [String : NSObject]){
                    self.searchResults.append(value as! [String : NSObject])
                    }
                    print(key)
                }
            }
        }
            print(self.tmpDict)
        
        return List
    }
    
    
    func loadfromserver(){
        var count = 0
        let tester = NSManagedObject()
//        if(tester.value(forKey: link) != nil){
//
//            let valu = tester.value(forKey: link)
//
//            for Style in (valu as? NSArray)!{
//                print((Style as! NSDictionary)["title"] as Any)
//                self.dict["\(count)"] = (Style as! NSDictionary)
//                count += 1
//            }
//            self.dictionnary = self.dict as NSDictionary
//            self.table.reloadData()
//        }
//        else{
        Alamofire.request(link, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["results"]
                
                for Style in (valu as? NSArray)!{
                    print((Style as! NSDictionary)["title"] as Any)
                    self.dict["\(count)"] = (Style as! NSDictionary)
                    count += 1
                }
                self.dictionnary = self.dict as NSDictionary
                self.table.reloadData()
                
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                let task = Datas(context: context) // Link Task & Context
                task.donnes = test
                
                // Save the data to coredata
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
//                    }
                }
            

        }
        }
    
    
    func save(name: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Person",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        
        // 4
        do {
            try managedContext.save()
//            Datas.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}

extension ViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchBar.text)
        if(searchBar.text != "" && !self.view.subviews.contains(tableSearch)){
            self.view.addSubview(tableSearch)
            UIView.animate(withDuration: 0.2) {
                self.tableSearch.alpha = 1
            }}
        if searchBar.text!.count >= 3 {
        DispatchQueue.main.async {
            self.loadData(searchedText : searchBar.text ?? "")
            
            }
        }
        
        
        if(searchBar.text == "" && self.view.subviews.contains(tableSearch)){
            self.view.addSubview(tableSearch)
            UIView.animate(withDuration: 0.2, animations: {
                self.tableSearch.alpha = 0
            }) { (true) in
                self.tableSearch.removeFromSuperview()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }

    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.addSubview(tableSearch)
        UIView.animate(withDuration: 0.2, animations: {
            self.tableSearch.alpha = 0
        }) { (true) in
            self.tableSearch.removeFromSuperview()
        }
    }
}

extension ViewController : UICollectionViewDelegate{
    func collectionView(_ CollectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        let newView = DetailViewController()
        newView.setdata(data: dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary,link: link,bg: (CollectionView.cellForItem(at: indexPath) as! Cells).backgroung.image! )
        let newImage = UIImageView()
        newImage.image = (CollectionView.cellForItem(at: indexPath) as! Cells).backgroung.image
        newImage.frame = self.view.frame
        newImage.alpha = 0
        newImage.center = self.view.center
        DispatchQueue.main.async {
            self.view.insertSubview(newImage, belowSubview: self.table)
            UIView.animate(withDuration: 0.2, animations: {
                for cells in self.table.visibleCells {
                    cells.alpha = 0
                }
            }, completion: nil)
            UIView.animate(withDuration: 0.5, animations: {
                newImage.alpha = 1
            }, completion: { (true) in
                self.navigationController?.pushViewController(newView, animated: false)
                CollectionView.alpha = 1
                for cells in self.table.visibleCells {
                    cells.alpha = 1
                }
                 newImage.removeFromSuperview()
            })
        }
    }
    
}



extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictionnary.allKeys.count
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.seachBar.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.seachBar.endEditing(true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! Cells
        cell.cellTitle.text = (dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary)["title"] as? String
        DispatchQueue.main.async {
            cell.setdata(data: (self.dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary))
            cell.textApparition()
        }
        return cell
    }


    func CollectionView(_ CollectionView: UICollectionView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
var imageCache = NSCache<NSString, UIImage>()


class headerView : UIView{

// let textView = U

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cells : UICollectionViewCell{
    var position : Int!
    var backgroung : UIImageView!
    var gradienView : UIView!
    var gardient : CAGradientLayer!
    var cellTitle : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroung = UIImageView()
        backgroung.frame = self.bounds
        cellTitle =  UILabel()
        cellTitle.frame = self.frame
        cellTitle.alpha = 0
        cellTitle.textColor = UIColor.white
        cellTitle.numberOfLines = 4
        cellTitle.adjustsFontSizeToFitWidth = true
        cellTitle.font = UIFont.boldSystemFont(ofSize: 60)
        cellTitle.textAlignment = .center
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = true
//        self.selectionStyle = .none
        self.backgroundView = backgroung
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func setdata(data : NSDictionary){
        downloadImage(url: ("https://image.tmdb.org/t/p/w500/" + (data["poster_path"] as! String)))
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    public func textApparition (){
//        self.addSubview(cellTitle)
        self.alpha = 0.3
        UIView.animate(withDuration: 1) {
            self.cellTitle.alpha = 1
             self.alpha = 1
            self.cellTitle.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }
    }
    
    public func downloadImage(url: String){
        let currentUrl = url
        if(imageCache.object(forKey: url as NSString) != nil){
            self.backgroung.image = imageCache.object(forKey: url as NSString)
        }else{

            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let task = session.dataTask(with: NSURL(string: url)! as URL, completionHandler: { (data, response, error) -> Void in
                if error == nil {
                    
                    DispatchQueue.main.async {
                        if let downloadedImage = UIImage(data: data!) {
                            if (url == currentUrl) {//Only cache and set the image view when the downloaded image is the one from last request
                                imageCache.setObject(downloadedImage, forKey: url as NSString)
                                self.backgroung.image = downloadedImage
                                self.backgroung.contentMode = .redraw
                                self.textApparition()
                            }

                        }
                    }

                }
                else {
                    print(error as Any)
                }
            })

            task.resume()
        }
        
        print(backgroung.image as Any)
    }
}

extension ViewController : UITableViewDelegate {
    
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellResult", for: indexPath)
        cell.textLabel?.text = "test"
        return cell
    }
    
    
    
    
    
}





