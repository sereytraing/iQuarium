//
//  DefaultVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 22/04/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DefaultVC: UIViewController {
    
    //let baseUrl = "http://iquarium.myftp.org:80"
    let baseUrl =  "http://iquarium.ddns.net"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavBarStyle()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBarStyle() {
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 216, green: 232, blue: 235)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(red: 255, green: 169, blue: 100)]
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255, green: 169, blue: 100)
    }
    
    func okAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logOut() {
        SessionManager.GetInstance().flush()
        let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = loginVC
        }, completion: { _ in })
    }
}
