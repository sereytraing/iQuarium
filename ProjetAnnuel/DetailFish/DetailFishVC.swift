//
//  DetailFishVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DetailFishVC: DefaultVC {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var aquariumLabel: UILabel!
    
    var fish: Fish?
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestGetAquarium()
    }

    func bindData() {
        if let fish = fish {
            self.nameLabel.text = fish.name
            self.specieLabel.text = "\(String(describing: fish.species?.commonNames?.first!))"
            self.heightLabel.text = "\(String(describing: fish.height)) cm"
            self.aquariumLabel.text = "\(String(describing: fish.aquarium?.name))"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestGetAquarium() {
        let url = self.baseUrl + "/fishes/" + (self.fish?.id)!
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Fish>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let fish = response.result.value {
                        self.fish = fish
                        self.bindData()
                    }
                    
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Get Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    @IBAction func showDetailAquarium(_ sender: Any) {
        //self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showUpdateFish(_ sender: Any) {
        let storyboard = UIStoryboard(name: "UpdateFish", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "updateFishVC") as? UpdateFishVC {
            if let fish = self.fish {
                controller.fish = fish
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
