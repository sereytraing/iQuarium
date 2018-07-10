//
//  UpdateFishVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 08/07/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class UpdateFishVC: DefaultVC {
    
    let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                    "Authorization": SessionManager.GetInstance().getToken()!]
    var fish: Fish?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.text = self.fish?.name
        self.heightTextField.text = "\(String(describing: self.fish!.height!))"
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor(red: 60, green: 85, blue: 121).cgColor
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if (self.nameTextField.text?.isEmpty)! || (self.heightTextField.text?.isEmpty)! {
            self.okAlert(title: "Erreur", message: "Entrez un nom et une taille")
        } else {
            self.requestUpdateFish(name: self.nameTextField.text!, height: Double(self.heightTextField.text!)!)
        }
    }
    
    func requestUpdateFish(name: String, height: Double) {
        let url = self.baseUrl + "/fishes/" + (self.fish?.id)!
        let parameters = [
            "name": name,
            "height": height
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Modification d'un poisson réussi", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                case .failure:
                    self.okAlert(title: "Erreur", message: "Erreur Update Fish \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
}
