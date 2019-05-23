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
    let moviedescBg : UIView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        MovieDescription.isEditable = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    var gradientLayer : CAGradientLayer!
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.MovieDescription.frame
        gradientLayer.colors = [UIColor.green, UIColor.white, UIColor.white, UIColor.white]
        
        self.moviedescBg.layer.addSublayer(gradientLayer)
        self.moviedescBg.layer.masksToBounds = true
    }
    
    func setView(){
        self.Image.frame = self.view.frame
        self.MovieDescription.frame = CGRect(x: 0, y: self.view.bounds.height * 2, width: self.view.bounds.width, height:self.view.bounds.height/2)
        self.moviedescBg.frame = self.MovieDescription.frame
        createGradientLayer()
        self.Title.frame = CGRect(origin: CGPoint(x: self.view.bounds.width + 200, y: self.view.bounds.height/2 - 20), size: CGSize(width: self.view.frame.width , height: 40))
        Title.font = UIFont.boldSystemFont(ofSize: 30)
        MovieDescription.font = UIFont.systemFont(ofSize: 14)
        MovieDescription.textColor = UIColor.black
        self.view.addSubview(Image)
        self.view.addSubview(MovieDescription)
        self.view.addSubview(Title)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.Title.frame = CGRect(origin: CGPoint(x: 0, y: self.view.bounds.height/2 - 20), size: CGSize(width: self.view.frame.width , height: 20))
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn], animations: {
        self.MovieDescription.frame = CGRect(x: 0 , y: self.view.bounds.height/2, width: self.view.bounds.width, height:self.view.bounds.height/2)
            
                    self.moviedescBg.frame = CGRect(x: 0 , y: self.view.bounds.height/2, width: self.view.bounds.width, height:self.view.bounds.height/2)
        }, completion: { (true) in
            
        })
    }
    
    func setdata(data : NSDictionary,link : String,bg : UIImage){
        self.Image.image = bg
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
