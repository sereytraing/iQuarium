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
    
    //Aquarium
    //Taille : double
    
    var species = [Species]()
    var select = ""
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestGetAllSpecies()
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func requestCreateFish(name: String, speciesId: String) {
        let url = self.baseUrl + "/fishes/"
        let parameters = [
            "name": name,
            "Species": speciesId
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Fish>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
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
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if (self.nameTextField.text?.isEmpty)! {
            self.okAlert(title: "Erreur", message: "Entrez un nom")
        } else {
            self.requestCreateFish(name: self.nameTextField.text!, speciesId: self.select)
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

