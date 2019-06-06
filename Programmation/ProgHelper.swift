//
//  ProgHelper.swift
//  Programmation
//
//  Created by ALEXENDRE OBLI on 05/06/2019.
//  Copyright © 2019 Alexendre. All rights reserved.
//


//This file contains all the elements created by myself to help in the programmation

import Foundation
import UIKit
import CoreData

var imageCache = NSCache<NSString, UIImage>()

struct moviesDatabase : Archivable {
    var Title : String?
    var description : String?
    var Image : String?
}

protocol Archivable: Codable {
    init?(data: Data?)
    func encode() -> Data?
}

struct categories : Archivable {
    var Name : String?
    var id : String?
}


class Cells : UICollectionViewCell{//Here is the definition of the cells used on the main collectionView 
    var position : Int!
    var backgroung = UIImageView()
    var gradienView : UIView!
    var gardient : CAGradientLayer!
    var cellTitle : UILabel!
    var datas : moviesDatabase!
    
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
    
    func setCellsdata(data : moviesDatabase){
        let img :UIImageView = UIImageView()
        if(imageCache.object(forKey: "https://image.tmdb.org/t/p/w500\(data.Image as! String)" as NSString) != nil){
            self.backgroung.image = imageCache.object(forKey: "https://image.tmdb.org/t/p/w500\(data.Image as! String)" as NSString)
        }else{
        DispatchQueue.main.async() {
            img.downloaded(from: "https://image.tmdb.org/t/p/w500\(data.Image as! String)", completionHandler: { (true) in
                print("https://image.tmdb.org/t/p/w500\(data.Image as! String)")
                
                self.backgroung.backgroundColor = UIColor.blue
                self.datas = data
                self.datas.Image = img.image?.jpegData(compressionQuality: 1)?.base64EncodedString()
                guard img.image == nil else { imageCache.setObject(img.image!, forKey: "https://image.tmdb.org/t/p/w500\(data.Image as! String)" as NSString)
                    self.backgroung.image = img.image
                    return}

            })
            }
            
        }
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
    

    public func downloadImage(url: String, completionHandler: @escaping (Bool) -> Void) -> UIImage{
        let currentUrl = url
        var tmpImage = UIImage()
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
                                tmpImage = downloadedImage
                                self.backgroung.image = downloadedImage
                                self.backgroung.contentMode = .redraw
                                self.textApparition()
                            }
                            
                        }
                        completionHandler(true)
                    }
                    
                }
                else {
                    print(error as Any)
                }
            })
            
            task.resume()
        }
        return tmpImage
    }
}

class headerView : UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        self.alpha = 0.5
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit, completionHandler: ((Bool)->Void)? ) {  // for swift 4.2 syntax just use ===> mode: UIView.ContentMode
        guard let url = URL(string: link) else { return }
        contentMode = mode
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
                completionHandler!(true)
            }
        }
        
    }
}
extension Archivable {
    init?(data: Data?) {
        guard let data = data else {
            return nil
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        self = try! decoder.decode(Self.self, from: data)
    }
    func encode() -> Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}

public class Disk {
    
    fileprivate init() { }
    
    enum Directory {
        /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored in the <Application_Home>/Documents directory and will be automatically backed up by iCloud.
        case documents
        
        /// Data that can be downloaded again or regenerated should be stored in the <Application_Home>/Library/Caches directory. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
        case caches
    }
    
    /// Returns URL constructed from specified directory
    static fileprivate func getURL(for directory: Directory) -> URL {
        var searchPathDirectory: FileManager.SearchPathDirectory
        
        switch directory {
        case .documents:
            searchPathDirectory = .documentDirectory
        case .caches:
            searchPathDirectory = .cachesDirectory
        }
        
        if let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not create URL for specified directory!")
        }
    }
    
    /**
     *   Store an encodable struct to the specified directory on disk
     *   @object: the encodable struct to store
     *   @directory: where to store the struct
     *   @fileName: what to name the file where the struct data will be stored
     */
    
    static func store<T: Archivable>(_ object: T, to directory: Directory, as fileName: String) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        do {
            let data = object.encode()
            if FileManager.default.fileExists(atPath: url.path) {
                try FileManager.default.removeItem(at: url)
            }
            FileManager.default.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /**
     *   Retrieve and convert a struct from a file on disk
     *   @fileName: name of the file where struct data is stored
     *   @directory: directory where struct data is stored
     *   @type: struct type (i.e. Message.self)
     *   @Returns: decoded struct model(s) of data
     */
    
    static func retrieve<T: Archivable>(_ fileName: String, from directory: Directory, as type: T.Type) -> T? {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            fatalError("File at path \(url.path) does not exist!")
        }
        
        if let data = FileManager.default.contents(atPath: url.path) {
            let model = type.init(data: data)
            return model
        } else {
            fatalError("No data found  at\(url.path)!")
        }
    }
    
    /// Remove all files at specified directory
    static func clear(_ directory: Directory) {
        let url = getURL(for: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
            for fileUrl in contents {
                try FileManager.default.removeItem(at: fileUrl)
            }
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    /// Remove specified file from specified directory
    static func remove(_ fileName: String, from directory: Directory) {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(at: url)
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }
    
    /// Returns BOOL indicating whether file exists at specified directory with specified file name
    static func fileExists(_ fileName: String, in directory: Directory) -> Bool {
        let url = getURL(for: directory).appendingPathComponent(fileName, isDirectory: false)
        return FileManager.default.fileExists(atPath: url.path)
    }
}


