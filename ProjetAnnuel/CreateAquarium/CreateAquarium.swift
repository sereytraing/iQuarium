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
    
    let volumeTabString = ["100 m³", "200 m³", "300 m³"]
    let volumeTabValue = [100, 200, 300]
    var select = 100
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.volumePickerView.delegate = self
        self.volumePickerView.dataSource = self
        self.select = self.volumeTabValue.first!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func submitButtonClicked(_ sender: Any) {
       // print(self.volumePickerView.sele)
        print(self.select)
    }
    
    func requestCreateAquarium() {
        let url = self.baseUrl + "/users/id/" + SessionManager.GetInstance().getId()!
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    if let aquarium = response.result.value {

                    }
                    
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
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
