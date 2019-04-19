//
//  ViewController.swift
//  ProgrammationMoblile
//
//  Created by ALEXENDRE OBLI on 12/04/2019.
//  Copyright © 2019 Alexendre. All rights reserved.
//

import UIKit
import Alamofire


class ViewController: UIViewController {
    let cellIdentifier = "CellIdentifier"
    let link = "https://api.themoviedb.org/4/list/5?page=1&api_key=e2afa493459356483ae71ef32311be3b&language=fr-FR"
    var dict =  Dictionary<String , Any>()
    var dictionnary = NSDictionary()

    let table : UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.frame = self.view.frame
        self.view.addSubview(table)
        table.dataSource = self
        table.delegate = self
        table.rowHeight = 400
        table.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        self.navigationController?.navigationBar.isHidden = true
       loadfromserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for cells in table.visibleCells{
            (cells.frame.origin.x = 0)
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    
    func loadfromserver(){
        var count = 0
        Alamofire.request(link, parameters: nil ,headers: nil) .responseJSON { response in
            if response.result.value != nil {
                let test = response.result.value as! NSDictionary
                let valu = test["results"]
                for Style in (valu as? NSArray)!{
                    print((Style as! NSDictionary)["title"])
                    self.dict["\(count)"] = (Style as! NSDictionary)
                    count += 1
                }
                self.dictionnary = self.dict as NSDictionary
                self.table.reloadData()
                
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
    func getImages(){
        
        
        
        
    }
}

extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        let newView = DetailViewController()
        newView.setdata(data: dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary,link: link)
        let newImage = UIImageView()
        newImage.image = (tableView.cellForRow(at: indexPath) as! Cells).backgroung.image
        newImage.frame = CGRect()
        newImage.center = self.view.center
        DispatchQueue.main.async {
             self.view.addSubview(newImage)
            UIImageView.animate(withDuration: 0.5, animations: {
                for cells in tableView.visibleCells{
                    (cells.frame.origin.x -= 1000)
                }
            }, completion: { (true) in
                self.navigationController?.pushViewController(newView, animated: true)
                tableView.alpha = 1
                 newImage.removeFromSuperview()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionnary.allKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Cells(style: .default, reuseIdentifier: "MyCell")
        cell.cellTitle.text = (dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary)["title"] as? String
        DispatchQueue.main.async {
            cell.setdata(data: (self.dictionnary.value(forKey: ("\(indexPath.row)")) as! NSDictionary))
            cell.textApparition()
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    

    
    
    
}
var imageCache = NSCache<NSString, UIImage>()


class headerView : UIView{
    
    var gradient : CAGradientLayer!
    
    let gradientOne = UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor
    let gradientTwo = UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
    let gradientThree = UIColor(red: 196/255, green: 70/255, blue: 107/255, alpha: 1).cgColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class Cells : UITableViewCell{
    var position : Int!
    var backgroung : UIImageView!
    var gradienView : UIView!
    var gardient : CAGradientLayer!
    var cellTitle : UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
       
        self.selectionStyle = .none
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
        self.addSubview(cellTitle)
        UIView.animate(withDuration: 1) {
            self.cellTitle.alpha = 1
            self.cellTitle.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        }
    }
    
    public func downloadImage(url: String){
        var currentUrl = url
        if(imageCache.object(forKey: url as NSString) != nil){
            self.backgroung.image = imageCache.object(forKey: url as NSString) as? UIImage
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
                    print(error)
                }
            })
            
            task.resume()
        }
        
        print(backgroung.image)
    }
}





