//
//  DetailAquariumVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DetailAquariumVC: DefaultVC {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var isDirtyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var aquarium: Aquarium?
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AquariumListCell", bundle: nil), forCellReuseIdentifier: "aquariumCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestGetAquarium()
    }
    
    func bindData() {
        if let aquarium = aquarium {
            self.nameLabel.text = aquarium.name
            self.volumeLabel.text = "\(String(describing: aquarium.volume!)) m³"
            self.isDirtyLabel.text = "\(String(describing: aquarium.isDirty))"
            
            if let temp = aquarium.temperatureReal {
                self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
            } else if let temp = aquarium.temperatureWanted {
                self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
            } else {
                self.temperatureLabel.text = "- °C"
            }
            self.tableView.reloadData()
        }
    }
    
    func requestGetAquarium() {
        let url = self.baseUrl + "/aquariums/" + (self.aquarium?.id)!
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let aquarium = response.result.value {
                        self.aquarium = aquarium
                        self.bindData()
                        self.tableView.reloadData()
                    }
                    
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Get Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    @IBAction func updateFishInAquarium(_ sender: Any) {
        let storyboard = UIStoryboard(name: "DetailAquarium", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "updateFishInAquariumVC") as? UpdateFishInAquariumVC {
            if let aquarium = self.aquarium {
                controller.aquarium = aquarium
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @IBAction func updateInfoClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "CreateAquarium", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "createAquariumVC") as? CreateAquarium {
            if let aquarium = self.aquarium {
                controller.wantToUpdate = true
                controller.aquariumToUpdate = aquarium
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

extension DetailAquariumVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fishes = self.aquarium?.fishes{
            return fishes.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aquariumCell", for: indexPath) as! AquariumListCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        
        if let fishes = self.aquarium?.fishes {
            cell.bindData(title: fishes[indexPath.row].name) //Peut ajouter imageurl
        } else {
            cell.bindData(title: "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailFish", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "DetailFishVC") as? DetailFishVC {
            if let fishes = self.aquarium?.fishes {
                controller.fish = fishes[indexPath.row]
            }
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
