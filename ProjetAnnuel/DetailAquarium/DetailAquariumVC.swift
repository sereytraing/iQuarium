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

class DetailAquariumVC: DefaultVC, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
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
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tableView.addGestureRecognizer(longPressGesture)
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
            self.title = aquarium.name
            self.volumeLabel.text = "\(String(describing: aquarium.volume!)) m³"
            self.isDirtyLabel.text = "\(String(describing: aquarium.isDirty))"
            
            if let temp = aquarium.temperatureReal {
                self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
            } else if let temp = aquarium.temperatureWanted {
                self.temperatureLabel.text = "\(String(describing: Int(temp)))°C"
            } else {
                self.temperatureLabel.text = "- °C"
            }
            
            if let pictures = aquarium.pictures, pictures.count > 0 {
                if let url = URL(string: (aquarium.pictures?.first)!) {
                    let data = try? Data(contentsOf: url)
                    self.imageView.image = UIImage(data: data!)
                } else {
                    self.imageView.image = UIImage(named: "aquarium_1")
                }
            } else {
                self.imageView.image = UIImage(named: "aquarium_1")
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
    
    func requestDeleteFishInAquarium(fishes: [String]) {
        let url = self.baseUrl + "/aquariums/" + (self.aquarium?.id)! + "/fishes/"
        let parameters = [
            "Fishes": fishes 
            ] as [String : Any]
        
        Alamofire.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Poisson retiré", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        self.requestGetAquarium()
                    }))
                    self.present(alert, animated: true, completion: nil)
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Create Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    
    func askDeleteFishInAquarium(index: Int) {
        let alert = UIAlertController(title: "Attention", message: "Voulez-vous enlever le poisson de l'aquarium ?", preferredStyle: UIAlertControllerStyle.alert)
        let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            let tabFish: [String] = [(self.aquarium?.fishes![index].id)!]
            self.requestDeleteFishInAquarium(fishes: tabFish)
        }
        alert.addAction(yesAction)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .ended {
            let touchPoint = gestureRecognizer.location(in: self.tableView)
            if let indexPath = self.tableView.indexPathForRow(at: touchPoint) {
                self.askDeleteFishInAquarium(index: indexPath.row)
            }
        }
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
            cell.view.backgroundColor = UIColor(red: 226, green: 241, blue: 243)
        } else {
            cell.view.backgroundColor = UIColor(red: 241, green: 250, blue: 248)
        }
        
        if let fishes = self.aquarium?.fishes {
            if let pictures = fishes[indexPath.row].species?.pictures, pictures.count > 0 {
                cell.bindData(title: fishes[indexPath.row].name, imageURL: pictures.first)
            } else {
                cell.bindData(title: fishes[indexPath.row].name)
            }
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
