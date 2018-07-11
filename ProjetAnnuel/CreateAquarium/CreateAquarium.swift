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
    @IBOutlet weak var addFishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var switchFavoris: UISwitch!
    @IBOutlet weak var hourPickerView: UIPickerView!
    @IBOutlet weak var minutePickerView: UIPickerView!
    @IBOutlet weak var addFishButtonView: UIView!
    @IBOutlet weak var separatorFishView: UIView!
    @IBOutlet weak var noFishViewLabel: UIView!
    @IBOutlet weak var viewTableView: UIView!
    
    let volumeTabString = ["100 L", "200 L", "300 L"]
    let volumeTabValue = [100, 200, 300]
    let hourTabString = ["0" ,"1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    let minuteTabString = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31", "32", "33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59"]
    var selectVolume = 100
    var selectHour = 0
    var selectMinute = 0
    var fishes = [Fish]()
    var fishesWithoutAquarium = [Fish]()
    var selectedIndexes = [Int]()
    var wantToUpdate = false
    var aquariumToUpdate: Aquarium?
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.volumePickerView.delegate = self
        self.volumePickerView.dataSource = self
        self.hourPickerView.delegate = self
        self.hourPickerView.dataSource = self
        self.minutePickerView.delegate = self
        self.minutePickerView.dataSource = self
        self.nameTextField.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsMultipleSelection = true
        self.selectVolume = self.volumeTabValue.first!
        self.selectHour = Int(self.hourTabString.first!)!
        self.selectMinute = Int(self.minuteTabString.first!)!
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.darkGray.cgColor
        self.addFishButton.layer.cornerRadius = 25
        self.addFishButton.layer.borderWidth = 1
        self.addFishButton.layer.borderColor = UIColor.white.cgColor
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "simpleCell")
        self.addFishButtonView.isHidden = self.wantToUpdate
        self.separatorFishView.isHidden = self.wantToUpdate
        self.viewTableView.isHidden = self.wantToUpdate
        if self.wantToUpdate && self.aquariumToUpdate != nil {
            self.nameTextField.text = self.aquariumToUpdate?.name
            self.switchFavoris.isOn = (self.aquariumToUpdate?.isFavorite)!
        }
        self.requestGetFishes()
        if self.wantToUpdate {
            self.title = "Modifier un aquarium"
        } else {
            self.title = "Créer un aquarium"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func submitButtonClicked(_ sender: Any) {
        if self.wantToUpdate {
            self.prepareRequestUpdateAquarium()
        } else {
            self.prepareRequestCreateAquarium()
        }
    }
    
    func prepareRequestUpdateAquarium() {
        if let name = self.nameTextField.text, !name.isEmpty {
            let cycle = self.selectHour * 3600 + self.selectMinute * 60
            self.requestUpdateAquarium(name: name, volume: self.selectVolume, isFavorite: self.switchFavoris.isOn, cycle: cycle)
        } else {
            self.okAlert(title: "Erreur", message: "error_name_temperature_aquarium_creation".localized)
        }
    }
    
    func prepareRequestCreateAquarium() {
        if let name = self.nameTextField.text, !name.isEmpty {
            var selectedFishes = [String]()
            var tempMin: Double?
            var tempMax: Double?
            var temp: Double?
            if !self.selectedIndexes.isEmpty {
                for index in self.selectedIndexes {
                    selectedFishes.append(self.fishes[index].id!)
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
            }
            let cycle = self.selectHour * 3600 + self.selectMinute * 60
            self.requestCreateAquarium(name: name, temperature: temp, volume: self.selectVolume, fishes: selectedFishes, isFavorite: self.switchFavoris.isOn, cycle: cycle)
            
        } else {
            self.okAlert(title: "Erreur", message: "error_name_temperature_aquarium_creation".localized)
        }
    }
    
    func requestCreateAquarium(name: String, temperature: Double?, volume: Int, fishes: [String], isFavorite: Bool, cycle: Int) {
        let url = self.baseUrl + "/aquariums/"
        let parametersFoodConf = [
            "cycle": cycle
            ] as [String : Any]
        let parameters = [
            "name": name,
            "intentedTemp": temperature,
            "volume": volume,
            "Fishes": fishes,
            "isFavorite": isFavorite,
            "FoodConfiguration" : parametersFoodConf
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Création d'un aquarium réussie", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func requestGetFishes() {
        let url = self.baseUrl + "/fishes/"
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseArray(completionHandler: { (response: DataResponse<[Fish]>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let fishes = response.result.value {
                        if fishes.count == 0 && !self.wantToUpdate {
                            self.noFishViewLabel.isHidden = false
                        } else {
                            for fish in fishes {
                                if fish.aquarium == nil {
                                    self.fishesWithoutAquarium.append(fish)
                                } else {
                                    self.fishes.append(fish)
                                }
                            }
                            self.noFishViewLabel.isHidden = true
                        }
                        self.fishesWithoutAquarium += self.fishes
                        self.tableView.reloadData()
                    }
                    
                case .failure:
                    if response.response?.statusCode == 204 {
                        
                    } else {
                        self.okAlert(title: "Erreur", message: "Erreur Get Fishes \(String(describing: response.response?.statusCode))")
                    }
                    if !self.wantToUpdate {
                        self.noFishViewLabel.isHidden = true
                    }
                }
            }
        })
    }
    
    func requestUpdateAquarium(name: String, volume: Int, isFavorite: Bool, cycle: Int) {
        let url = self.baseUrl + "/aquariums/"
        let parametersFoodConf = [
            "cycle": cycle
            ] as [String : Any]
        let parameters = [
            "name": name,
            "volume": volume,
            "isFavorite": isFavorite,
            "FoodConfiguration" : parametersFoodConf
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Modification d'un aquarium réussie", preferredStyle: UIAlertControllerStyle.alert)
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
}

extension CreateAquarium: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.volumePickerView {
            return self.volumeTabString.count
        }
        if pickerView == self.hourPickerView {
            return self.hourTabString.count
        }
        return self.minuteTabString.count
    }
    
    private func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        if pickerView == self.volumePickerView {
            return self.volumeTabString[row]
        }
        if pickerView == self.hourPickerView {
            return self.hourTabString[row]
        }
        return self.minuteTabString[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == self.volumePickerView {
            self.selectVolume = self.volumeTabValue[row]
        }
        else if pickerView == self.hourPickerView {
            self.selectHour = Int(self.hourTabString[row])!
        }
        else if pickerView == self.minutePickerView {
            self.selectMinute = Int(self.minuteTabString[row])!
        }
        print(self.selectVolume)
        print(self.selectHour)
        print(self.selectMinute)
    }
}

extension CreateAquarium: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fishesWithoutAquarium.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "simpleCell", for: indexPath) as! SimpleCell
        cell.view.backgroundColor = UIColor(red: 241, green: 250, blue: 248)
        for fish in self.fishesWithoutAquarium {
            if fish.aquarium == nil {
                cell.bindData(title: self.fishesWithoutAquarium[indexPath.row].name!)
            } else {
                cell.bindData(title: self.fishesWithoutAquarium[indexPath.row].name!, nameAquarium: self.fishesWithoutAquarium[indexPath.row].aquarium?.name)
            }
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.selectedIndexes.contains(indexPath.row) {
            self.selectedIndexes.append(indexPath.row)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        print(self.selectedIndexes)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if self.selectedIndexes.contains(indexPath.row) {
            if let index = self.selectedIndexes.index(of: indexPath.row) {
                self.selectedIndexes.remove(at: index)
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            }
        }
        print(self.selectedIndexes)
    }
}

extension CreateAquarium: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}


