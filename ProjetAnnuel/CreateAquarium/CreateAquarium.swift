//
//  CreateAquarium.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 29/06/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CreateAquarium: DefaultVC {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var volumePickerView: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var temperatureTextField: UITextField!
    @IBOutlet weak var addFishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let volumeTabString = ["100 m³", "200 m³", "300 m³"]
    let volumeTabValue = [100, 200, 300]
    var select = 100
    var fishes = [Fish]()
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.volumePickerView.delegate = self
        self.volumePickerView.dataSource = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.select = self.volumeTabValue.first!
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addFishButton.layer.cornerRadius = 25
        self.addFishButton.layer.borderWidth = 1
        self.addFishButton.layer.borderColor = UIColor.white.cgColor
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "simpleCell")
        self.requestGetFishes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func submitButtonClicked(_ sender: Any) {
        if let name = self.nameTextField.text, let temperature = self.temperatureTextField.text, !name.isEmpty && !temperature.isEmpty {
            if let tempValue = Double(temperature) {
                self.requestCreateAquarium(name: name, temperature: tempValue, volume: self.select)
            } else {
                self.okAlert(title: "Erreur", message: "error_name_temperature_aquarium_creation".localized)
            }
        } else {
            self.okAlert(title: "Erreur", message: "error_name_temperature_aquarium_creation".localized)
        }
    }
    
    func requestCreateAquarium(name: String, temperature: Double, volume: Int) {
        let url = self.baseUrl + "/aquariums/"
        let parameters = [
            "name": name,
            "temperature": temperature,
            "volume": volume,
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    self.navigationController?.popViewController(animated: true)
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Create Aquarium \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func requestGetFishes() {
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
                    self.okAlert(title: "Erreur", message: "Erreur Get Fishes \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
}

extension CreateAquarium: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.volumeTabString.count
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return self.volumeTabString[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       self.select = self.volumeTabValue[row]
    }
}

extension CreateAquarium: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! SimpleCell
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

    }
}
