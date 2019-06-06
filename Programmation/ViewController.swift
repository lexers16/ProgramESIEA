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
    let titleView = UILabel()
    var categoriesArray = [categories]()
    var tmpDict : [moviesDatabase] = [moviesDatabase]()
    var CategorySelector : UINavigationItem!
    var catTapped = false
    var table : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
        loadCat()
        titleView.frame = CGRect(x: 0 ,y: (navigationController?.navigationBar.frame.maxY)!, width: self.view.frame.width, height: 60)
        titleView.text = "Most rated Marvel Movies"
        titleView.textAlignment = .center
        titleView.font = .boldSystemFont(ofSize: 40)
        titleView.textColor = UIColor.white
        
        catView.alpha = 0.5
        
        self.title = "Movie rater"
        catView.frame = CGRect(x: self.view.frame.width, y: 0, width: self.view.frame.width/2, height: self.view.frame.height)
        catView.register(UITableViewCell.self, forCellReuseIdentifier: "CellResult")
        
        catView.dataSource = self
        catView.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 50, left: 10, bottom: 5, right: 10)
        layout.itemSize = CGSize(width: 100, height: 150)
        layout.scrollDirection = .vertical
        table = UICollectionView(frame: CGRect(x: 0, y: titleView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - titleView.frame.height), collectionViewLayout: layout)
        
        background.frame = CGRect(x: 0,y: 0,width: self.view.frame.width*5,height: self.view.frame.height)
        //        background.image = UIImage(named: "avengers-comic-con")
        //        background.alpha = 0.5
        //        self.view.addSubview(background)
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.backgroundColor = UIColor.clear
        table.register(Cells.self, forCellWithReuseIdentifier: "MyCell")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Category", style: .plain, target: self, action: #selector(barAction))
        self.view.addSubview(catView)
        self.view.addSubview(titleView)
        loadfromserver(urlLink: link, completion: {(true) in
            self.creatdata()
        })
        
    }
    
    @objc func barAction() {
        // Function body goes here
        print("Tapped")
        if !catTapped{
            UIView.animate(withDuration: 0.3, animations: {
                self.titleView.alpha = 0
                self.table.frame.origin.x -= self.view.frame.width/2
                self.catView.frame.origin.x -= self.view.frame.width/2
            }) { (true) in
                self.catTapped = true
            }
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.table.frame.origin.x = 0
                self.titleView.alpha = 1
                self.catView.frame.origin.x = self.view.frame.width
            }) { (true) in
                self.catTapped = false
            }
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
    func loadfromserver(urlLink : String,completion :  @escaping (Bool) -> Void){
        var count = 0
        Alamofire.request(urlLink, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["results"]
                
                for Style in (valu as? NSArray)!{
                    print((Style as! NSDictionary)["title"] as Any)
                    self.dict["\(count)"] = moviesDatabase(Title: (Style as! NSDictionary)["title"] as? String, description: (Style as! NSDictionary)["overview"] as? String, Image:(Style as! NSDictionary)["poster_path"] as? String)
                    self.tmpDict.append(self.dict["\(count)"] as! moviesDatabase)
                    count += 1
                }
                self.dictionnary = self.dict as NSDictionary
                print(self.dictionnary)
                completion(true)
                self.table.reloadData()
                self.catView.reloadData()
                }
            }
        }
    
    func loadCat(){
        let lien = self.getGenre
        Alamofire.request(lien, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["genres"] as! NSArray
                for key in valu{
                    self.categoriesArray.append(categories(Name: (key as! NSDictionary)["name"] as? String,id : String((key as! NSDictionary)["id"] as! Int)))
                    
                }
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
    
    func creatdata(){
        
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "Datas", in: managedContext)!
        
        for movies in tmpDict {
            let movie = NSManagedObject(entity: userEntity, insertInto: managedContext)
            movie.setValue(movies.description, forKey: "movie_description")
            movie.setValue(movies.Image, forKey: "images")
            movie.setValue(movies.Title, forKey: "title")
            print("movie \(movies.Title) enrg")
        }
        
        do {
            try managedContext.save()
            
        }catch let error as NSError{
            print("could not save ")
        }
    }
    
    func retrieveData(){
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
    
    let managedContext = appDelegate.persistentContainer.viewContext
    
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Datas")
        
        do {
            let results = try managedContext.fetch(fetch)
            var count = 0
            for data in results as! [NSManagedObject]{
                dict["\(count)"] = moviesDatabase(Title: data.value(forKey: "title") as? String, description: data.value(forKey: "movie_description") as? String, Image: data.value(forKey: "images") as? String)
                dictionnary = dict as NSDictionary
                count += 1
            }
        }
        catch{
            print("raté")
            
        }
        
        
    }
    
}
extension ViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dictionnary.allKeys.count
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
        tmpDict.removeAll()
        self.titleView.text = categoriesArray[indexPath.row].Name
        loadfromserver(urlLink: "https://api.themoviedb.org/3/discover/movie?api_key=e2afa493459356483ae71ef32311be3b&with_genres=\(categoriesArray[indexPath.row].id ?? "0")", completion: {(true) in })
        barAction()
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
