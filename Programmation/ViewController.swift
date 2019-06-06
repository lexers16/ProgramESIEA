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
let getGenre = "https://api.themoviedb.org/3/genre/movie/list?api_key=e2afa493459356483ae71ef32311be3b&language=en-US"
    var dict =  Dictionary<String , Any>()
    var dictionnary = NSDictionary()
    let background = UIImageView()
    let catView = UITableView()
    var categoriesArray = [categories]()
    var tmpDict : [moviesDatabase] = [moviesDatabase]()
    var seachBar : UISearchBar = UISearchBar()
    var tableSearch : UITableView = UITableView()
    var searchResults : [moviesDatabase] = [moviesDatabase]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = NSManagedObjectContext()
    var CategorySelector : UINavigationItem!
    var catTapped = false

    var table : UICollectionView!
    
    func setCoreData(){
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Datas", in: context)
    }
    
    func saveData(){
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func fecthdata(){
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "username") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCoreData()
        seachBar.delegate = self
        
        catView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
        
        
        seachBar.frame = CGRect(x: self.view.safeAreaInsets.left, y: (self.navigationController?.navigationBar.frame.maxY)!, width: self.view.bounds.width, height: 40)
        seachBar.returnKeyType = .go
        tableSearch.frame = CGRect(x: self.view.safeAreaInsets.left, y: seachBar.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - seachBar.frame.maxY)
        tableSearch.alpha = 0
        catView.register(UITableViewCell.self, forCellReuseIdentifier: "CellResult")
        
        catView.dataSource = self
        catView.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 10, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .vertical
        table = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), collectionViewLayout: layout)
        
        background.frame = CGRect(x: 0,y: 0,width: self.view.frame.width*5,height: self.view.frame.height)
        background.image = UIImage(named: "avengers-comic-con")
        self.view.addSubview(background)

        self.view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.clear
        table.register(Cells.self, forCellWithReuseIdentifier: "MyCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Category", style: .plain, target: self, action: #selector(barAction))
        
        self.view.addSubview(seachBar)
        self.view.addSubview(catView)
        loadfromserver()
    }
    
    @objc func barAction(sender: UIBarButtonItem) {
        // Function body goes here
        print("Tapped")
        if !catTapped{
            UIView.animate(withDuration: 0.3, animations: {
                self.table.frame.origin.x -= self.view.frame.width/2
                self.catView.frame.origin.x -= self.view.frame.width/2
            }) { (true) in
                self.catTapped = true
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.table.frame.origin.x = 0
                self.catView.frame.origin.x = self.view.frame.width
            }) { (true) in
                self.catTapped = false
            }
        }
        
        for cat in categoriesArray{
        
            
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
        self.background.frame.origin.x = 0
        DispatchQueue.main.async {
        UIView.animate(withDuration: 120, delay: 0, options: [.repeat,.curveEaseInOut,.autoreverse], animations: {
            self.background.frame.origin.x = -self.view.frame.width*4
        }, completion: nil)
        }
    }
    
    func  loadData(searchedText : String,completionHandler: ((Bool)->Void)?){
        var lien = "https://api.themoviedb.org/3/search/movie?api_key=e2afa493459356483ae71ef32311be3b&language=fr-FR&query=\(searchedText)&page=1&include_adult=false"
        Alamofire.request(lien, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                self.searchResults.removeAll()
                let test = response.result.value as! NSDictionary
                let valu = test["results"] as! NSArray
                for key in valu{
                    var tmpMovie : moviesDatabase = moviesDatabase(Title: (key as! NSDictionary)["title"] as? String, description: (key as! NSDictionary)["overview"] as? String, Image:(key as! NSDictionary)["poster_path"] as? String)
                    let value = key as? NSDictionary
                    if self.searchResults.contains(where: { ($0 ).description == tmpMovie.description }) {
                        // 1 is found
                    }
                    self.searchResults.append(tmpMovie)
                    completionHandler!(true)
                }
            }
            lien = getGenre
            Alamofire.request(lien, parameters: nil ,headers: nil) .responseJSON { response in
                if response.result.value != nil {
                    
                    
                    
                    
                }
            
            
        }
    }
    func loadfromserver(){
        var count = 0
        Alamofire.request(link, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["results"]
                
                for Style in (valu as? NSArray)!{
                    print((Style as! NSDictionary)["title"] as Any)
                    self.categoriesArray.append(categories(Name: (Style as! NSDictionary)["title"] as? String))
                    self.dict["\(count)"] = moviesDatabase(Title: (Style as! NSDictionary)["title"] as? String, description: (Style as! NSDictionary)["overview"] as? String, Image:(Style as! NSDictionary)["poster_path"] as? String)
                    count += 1
                }
                self.dictionnary = self.dict as NSDictionary
                print(self.dictionnary)
                self.table.reloadData()
                self.catView.reloadData()
                }
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
        print(searchBar.text as Any)
        if(searchBar.text != "" && !self.view.subviews.contains(tableSearch)){
            self.view.addSubview(tableSearch)
            UIView.animate(withDuration: 0.2) {
                self.tableSearch.alpha = 1
            }}
        if searchBar.text!.count >= 3 {
        DispatchQueue.main.async {
            self.loadData(searchedText : searchBar.text ?? "", completionHandler: {(true) in
                self.tableSearch.reloadSections(IndexSet(integer: 0), with: .automatic)
            })
            
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
        newView.setdata(data: (CollectionView.cellForItem(at: indexPath) as! Cells).datas,link: link)
        let newImage = UIImageView()
        newImage.image = newView.Image.image
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
        if (seachBar.text!.count <= 0){
            self.seachBar.endEditing(true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.seachBar.endEditing(true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! Cells
        cell.cellTitle.text = (dictionnary.value(forKey: ("\(indexPath.row)")) as! moviesDatabase).Title
        DispatchQueue.main.async {
            cell.setCellsdata(data: (self.dictionnary.value(forKey: ("\(indexPath.row)")) as! moviesDatabase))
            cell.textApparition()
        }
        return cell
    }


    func CollectionView(_ CollectionView: UICollectionView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellResult", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].Name
        return cell
    }
}


