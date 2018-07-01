//
//  HomeVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 22/04/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class HomeVC: DefaultVC, UIScrollViewDelegate{

    var user: User?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noAquariumView: UIView!
    @IBOutlet weak var homeView: UIView!
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestGetProfile()
        self.scrollView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestGetProfile() {
        let url = self.baseUrl + "/users/id/" + SessionManager.GetInstance().getId()!
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let user = response.result.value {
                        self.user = user
                        // TODO: A CHANGER APRES LES TESTS
                        if let aquarium = self.user?.aquariums, aquarium.isEmpty {
                            self.noAquariumView.isHidden = false
                            self.homeView.isHidden = true
                        } else {
                            self.noAquariumView.isHidden = true
                            self.homeView.isHidden = false
                        }
                    }
                    
                case .failure:
                    self.logOut()
                    self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    @IBAction func tmp(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        self.logOut()
    }
}
