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
    @IBOutlet weak var mesAquariumsView: UIView!
    @IBOutlet weak var mesPoissonsView: UIView!
    
    @IBOutlet weak var nameAquarium: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var isDirtyLabel: UILabel!
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "iQuarium"
        self.scrollView.delegate = self
        self.mesPoissonsView.layer.masksToBounds = true
        self.mesAquariumsView.layer.masksToBounds = true
        self.mesPoissonsView.layer.cornerRadius = 20.0
        self.mesAquariumsView.layer.cornerRadius = 20.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestGetProfile()
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
                            self.bindData()
                        }
                    }
                    
                case .failure:
                    self.logOut()
                    self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func bindData() {
        if self.user?.aquariums?.count == 1 {
            if let aquarium = self.user?.aquariums?.first {
                self.nameAquarium.text = aquarium.name
                if aquarium.isDirty! {
                    self.isDirtyLabel.text = "Sale"
                } else {
                    self.isDirtyLabel.text = "Propre"
                }
                if let temp = aquarium.temperatureReal {
                    self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
                } else if let temp = aquarium.temperatureWanted {
                    self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
                } else {
                    self.temperatureLabel.text = "- °C"
                }
            }
            return
        }
        if let aquariums = self.user?.aquariums {
            for aquarium in aquariums {
                if aquarium.isFavorite! {
                    self.nameAquarium.text = aquarium.name
                    if aquarium.isDirty! {
                        self.isDirtyLabel.text = "Sale"
                    } else {
                        self.isDirtyLabel.text = "Propre"
                    }
                    if let temp = aquarium.temperatureReal {
                        self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
                    } else if let temp = aquarium.temperatureWanted {
                        self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
                    } else {
                        self.temperatureLabel.text = "- °C"
                    }
                    return
                }
            }
        }
    }
    
    @IBAction func tmp(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func logOutClicked(_ sender: Any) {
        self.logOut()
    }
    
    @IBAction func feedFishClicked(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Êtes-vous sùr de vouloir nourrir vos poissons ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            //self.feedFish()
        }
        let closeAction = UIAlertAction(title: "Non ", style: UIAlertActionStyle.default) {
            UIAlertAction in
           
        }
        alert.addAction(okAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
}
