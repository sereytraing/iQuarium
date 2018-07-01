//
//  ListFishesVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ListFishesVC: DefaultVC {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var fishes = [Fish]()
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 25.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AquariumListCell", bundle: nil), forCellReuseIdentifier: "aquariumCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestGetAllFishes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
                        self.okAlert(title: "Aucun contenu", message: "Veuillez ajouter un poisson")
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Fishes \(String(describing: response.response?.statusCode))")
                    }
                    
                }
            }
        })
    }

}

extension ListFishesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aquariumCell", for: indexPath) as! AquariumListCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        
        cell.bindData(title: self.fishes[indexPath.row].name) //Peut ajouter imageurl
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let trackVC = TrackVC(nibName: TrackVC.className(), bundle: nil)
         trackVC.item = allItems[indexPath.row]
         navigationController?.pushViewController(trackVC, animated: true)*/
    }
}
