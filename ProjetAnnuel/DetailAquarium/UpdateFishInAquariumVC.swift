//
//  UpdateFishInAquariumVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 08/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class UpdateFishInAquariumVC: DefaultVC {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    var fishes = [Fish]()
    var aquarium: Aquarium?
    var selectedIndexes = [Int]()
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindData()
       
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        self.tableView.register(UINib(nibName: "AquariumListCell", bundle: nil), forCellReuseIdentifier: "aquariumCell")
         self.requestGetAllFishes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bindData() {

    }
    
    func requestGetAllFishes() {
        let url = self.baseUrl + "/fishes/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Fish]>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let fishes = response.result.value {
                        self.fishes = fishes
                        self.tableView.reloadData()
                    }
                    
                case .failure:
                    if response.response?.statusCode == 204 {
                        self.fishes = []
                        self.tableView.reloadData()
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Fishes \(String(describing: response.response?.statusCode))")
                    }
                    
                }
            }
        })
    }
    
    func requestUpdateFishInAquarium(fishes: [String], temp: Double?) {
        let url = self.baseUrl + "/aquariums/" + (self.aquarium?.id)! + "/fishes/"
        let parameters = [
            "intentedTemp": temp,
            "Fishes": fishes
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Ajout d'un poisson réussi", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Create Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    @IBAction func updateFishInAquariumClicked(_ sender: Any) {
        var selectedFish = [String]()
        var tempMin: Double?
        var tempMax: Double?
        var temp: Double?
        
        for fish in (self.aquarium?.fishes)! {
            if tempMin == nil {
                tempMin = fish.species?.tempMin
            } else {
                if tempMin! < (fish.species?.tempMin)! {
                    tempMin = fish.species?.tempMin
                }
            }
            
            if tempMax == nil {
                tempMax = fish.species?.tempMax
            } else {
                if tempMax! > (fish.species?.tempMax)! {
                    tempMax = fish.species?.tempMax
                }
            }
        }
        
        for index in self.selectedIndexes {
            selectedFish.append(self.fishes[index].id!)
            
            if tempMin == nil {
                tempMin = self.fishes[index].species?.tempMin
            } else {
                if tempMin! < (self.fishes[index].species?.tempMin!)! {
                    tempMin = self.fishes[index].species?.tempMin
                }
            }
            
            if tempMax == nil {
                tempMax = self.fishes[index].species?.tempMax
            } else {
                if tempMax! > (self.fishes[index].species?.tempMax!)! {
                    tempMax = self.fishes[index].species?.tempMax
                }
            }
            if tempMax != nil && tempMin != nil {
                temp = ( tempMax! + tempMin! ) / 2.0
            }
        }
        
        self.requestUpdateFishInAquarium(fishes: selectedFish, temp: temp)
    }
}

extension UpdateFishInAquariumVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aquariumCell", for: indexPath) as! AquariumListCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        
        if self.fishes.count > 0 {
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
        if !self.selectedIndexes.contains(indexPath.row) {
            self.selectedIndexes.append(indexPath.row)
        }
        print(self.selectedIndexes)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.selectedIndexes.contains(indexPath.row) {
            if let index = self.selectedIndexes.index(of: indexPath.row) {
                self.selectedIndexes.remove(at: index)
            }
        }
        print(self.selectedIndexes)
    }
}
