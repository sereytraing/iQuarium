//
//  ListAquariumVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class ListAquariumVC: DefaultVC, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var aquariums = [Aquarium]()
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 25.0
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AquariumListCell", bundle: nil), forCellReuseIdentifier: "aquariumCell")
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.requestGetAllAquarium()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestGetAllAquarium() {
        let url = self.baseUrl + "/aquariums/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Aquarium]>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let aquariums = response.result.value {
                        self.aquariums = aquariums
                        self.tableView.reloadData()
                    }
                    
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Get Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func requestRemoveAquarium(id: String) {
        let url = self.baseUrl + "/aquariums/" + id
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    self.requestGetAllAquarium()
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Remove Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func askDeleteAquarium(index: Int) {
            let alert = UIAlertController(title: "Attention", message: "Voulez-vous supprimer l'aquarium ?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.requestRemoveAquarium(id: self.aquariums[index].id!)
            }
            alert.addAction(yesAction)
            alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }

    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                self.askDeleteAquarium(index: indexPath.row)
            }
        }
    }
}

extension ListAquariumVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aquariums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aquariumCell", for: indexPath) as! AquariumListCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        
        cell.bindData(title: self.aquariums[indexPath.row].name) //Peut ajouter imageurl
        
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
