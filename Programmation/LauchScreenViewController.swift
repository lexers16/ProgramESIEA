//
//  LauchScreenViewController.swift
//  Programmation
//
//  Created by ALEXENDRE OBLI on 10/05/2019.
//  Copyright © 2019 Alexendre. All rights reserved.
//

import UIKit

class LauchScreenViewController: UIViewController {

    @IBOutlet weak var Name: UILabel!
    
    var color : [UIColor] = [UIColor.black,UIColor.blue,UIColor.red,UIColor.yellow,UIColor.cyan,UIColor.green]
    override func viewDidLoad() {
        super.viewDidLoad()
        let offset = 0
//        for colors in color{
//            UIView.animate(withDuration: 0.2) {
//                self.Name.textColor = colors
//@
//            }
//            offset += 1
//        }
        if offset == color.count - 1 {
            self.dismiss(animated: true, completion: nil)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
