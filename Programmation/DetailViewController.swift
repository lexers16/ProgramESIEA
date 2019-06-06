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
        MovieDescription.textAlignment = .center
        MovieDescription.alpha = 0
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.2) {
              self.MovieDescription.alpha = 0.7
        }
      
    }

    func setView(){
        self.Image.frame = self.view.frame
        self.MovieDescription.frame = CGRect(x: 0, y: self.view.bounds.height * 2, width: self.view.bounds.width, height:self.view.bounds.height/3)
        
        self.moviedescBg.frame = self.MovieDescription.frame
        self.Title.frame = CGRect(origin: CGPoint(x: self.view.bounds.width + 200, y: (self.navigationController?.navigationBar.frame.maxY)! + 10), size: CGSize(width: self.view.frame.width , height: 40))
        Title.font = UIFont.boldSystemFont(ofSize: 30)
        MovieDescription.font = UIFont.systemFont(ofSize: 14)
        MovieDescription.textColor = UIColor.black
        MovieDescription.adjustsFontForContentSizeCategory = true
        Title.textColor = UIColor.white
        self.view.addSubview(Image)
        self.view.addSubview(MovieDescription)
        self.view.addSubview(Title)
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
            self.Title.frame = CGRect(origin: CGPoint(x: 0, y: (self.navigationController?.navigationBar.frame.maxY)! + 10), size: CGSize(width: self.view.frame.width , height: 20))
        }, completion: nil)

        UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn], animations: {
            self.MovieDescription.center = self.view.center
            
                    self.moviedescBg.frame = CGRect(x: 0 , y: self.view.bounds.height/2, width: self.view.bounds.width, height:self.view.bounds.height/2)
        }, completion: { (true) in
            
        })
    }
    
    func setdata(data : moviesDatabase,link : String){
        let img :UIImageView = UIImageView()
        img.image = UIImage.init(data: Data(base64Encoded: data.Image!)!)
        self.MovieDescription.text = data.description
        self.Title.text = data.Title
        if(imageCache.object(forKey: data.Image! as NSString) != nil){
            self.Image.image = imageCache.object(forKey: data.Image! as NSString)
        }else{
            Image.image = img.image
        }
        self.title = data.Title
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
