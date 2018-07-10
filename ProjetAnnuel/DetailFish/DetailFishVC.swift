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
    @IBOutlet weak var commonSpecieName: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var aquariumLabel: UILabel!
    @IBOutlet weak var rarityLabel: UILabel!
    
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
        if let fish = fish, let specie = fish.species {
            self.nameLabel.text = fish.name
            self.title = fish.name
            self.specieLabel.text = specie.scientificName!
            self.heightLabel.text = "\(String(describing: fish.height!)) cm"
            self.rarityLabel.text = specie.rarety!
            
            if let aquarium = fish.aquarium {
                self.aquariumLabel.text = "\(String(describing: (aquarium.name)!))"
            } else {
                self.aquariumLabel.text = "Aucun"
            }
            
            var fullCommonName = ""
            for name in specie.commonNames! {
                fullCommonName += name + ", "
            }
            if fullCommonName != "" {
                fullCommonName = String(fullCommonName.dropLast())
                fullCommonName = String(fullCommonName.dropLast())
            }
            
            self.commonSpecieName.text = fullCommonName
            
            if let pictures = specie.pictures, pictures.count > 0 {
                if let url = URL(string: (specie.pictures?.first)!) {
                    let data = try? Data(contentsOf: url)
                    self.imageView.image = UIImage(data: data!)
                } else {
                    self.imageView.image = UIImage(named: "fish_1")
                }
            } else {
                self.imageView.image = UIImage(named: "fish_1")
            }
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
