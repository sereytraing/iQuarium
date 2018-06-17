//
//  HomeVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 22/04/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit

class HomeVC: DefaultVC {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tmp(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
}
