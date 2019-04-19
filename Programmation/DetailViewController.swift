//
//  DetailViewController.swift
//  Programmation
//
//  Created by ALEXENDRE OBLI on 14/04/2019.
//  Copyright © 2019 Alexendre. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {
    
    let Image : UIImageView = UIImageView()
    let Title : UILabel = UILabel()
    let MovieDescription : UITextView = UITextView()
    let DescriptionBg = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        setView()
        MovieDescription.isEditable = false
        MovieDescription.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        
        // Do any additional setup after loading the view.
    }
    
    func setView(){
        self.Image.frame = self.view.frame
        self.MovieDescription.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 20, width: self.view.bounds.width, height: self.view.frame.height/2 )
        self.Title.frame = CGRect(origin: CGPoint(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! ), size: CGSize(width: self.view.frame.width , height: 20))
        Title.font = UIFont.boldSystemFont(ofSize: 20)
        MovieDescription.font = UIFont.boldSystemFont(ofSize: 30)
        DescriptionBg.frame = self.view.frame
        DescriptionBg.backgroundColor = UIColor.white
        DescriptionBg.alpha = 0.3
        MovieDescription.textColor = UIColor.white
        self.view.addSubview(Image)
        self.view.addSubview(DescriptionBg)
        self.view.addSubview(MovieDescription)
        self.view.addSubview(Title)
    }
    
    func setdata(data : NSDictionary,link : String){
        self.MovieDescription.text = data["overview"] as? String
        self.Title.text = data["title"] as? String
        if(imageCache.object(forKey: "https://image.tmdb.org/t/p/w500/" + (data["poster_path"] as! String) as NSString) != nil){
            self.Image.image = imageCache.object(forKey: "https://image.tmdb.org/t/p/w500/" + (data["poster_path"] as! String) as NSString)
        }
        self.title = data["title"] as? String
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    

    
    
}
