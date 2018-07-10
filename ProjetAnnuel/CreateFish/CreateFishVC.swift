//
//  CreateFishVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 01/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CreateFishVC: DefaultVC {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    //Aquarium
    //Taille : double
    var aquariums = [Aquarium]()
    var selectedAquarium: Aquarium?
    var species = [Species]()
    var select = ""
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestGetAllSpecies()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "simpleCell")
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor(red: 60, green: 85, blue: 121).cgColor
        self.requestGetAquariums()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestCreateFish(name: String, speciesId: String, size: Double, idAquarium: String?) {
        let url = self.baseUrl + "/fishes/"
        let parameters = [
            "name": name,
            "Species": speciesId,
            "height": size,
            "Aquarium": idAquarium
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Fish>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Création d'un poisson réussie", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Create Fish \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func requestGetAllSpecies() {
        let url = self.baseUrl + "/species/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Species]>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let species = response.result.value {
                        self.species = species
                        self.select = (species.first?.id)!
                        self.pickerView.reloadAllComponents()
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
    
    func requestGetAquariums() {
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
                    self.okAlert(title: "Erreur", message: "Erreur Get Aquariums \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if (self.nameTextField.text?.isEmpty)! && (self.sizeTextField.text?.isEmpty)! {
            self.okAlert(title: "Erreur", message: "Entrez un nom et une taille")
        } else {
            self.requestCreateFish(name: self.nameTextField.text!, speciesId: self.select, size: Double(self.sizeTextField.text!)!, idAquarium: self.selectedAquarium?.id)
        }
        
    }
}

extension CreateFishVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.species.count
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        if !self.species.isEmpty {
            return (self.species[row].commonNames?.first)!
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.select = self.species[row].id!
    }
}

extension CreateFishVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aquariums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! SimpleCell
        cell.view.backgroundColor = UIColor(red: 226, green: 241, blue: 243)
        cell.bindData(title: self.aquariums[indexPath.row].name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedAquarium = self.aquariums[indexPath.row]
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
    }
}

