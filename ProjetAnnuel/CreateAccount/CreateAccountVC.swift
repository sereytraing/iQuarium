//
//  CreateAccountVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 22/04/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class CreateAccountVC: DefaultVC {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    let header: HTTPHeaders = ["Content-Type": "application/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.darkGray.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func submitClicked(_ sender: Any) {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text, !username.isEmpty && !password.isEmpty {
            self.requestCreateAccount(username: self.usernameTextField.text!, password: self.passwordTextField.text!)
        } else {
            self.okAlert(title: "Erreur", message: "error_username_password".localized)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func requestCreateAccount(username: String, password: String) {
        let url = self.baseUrl + "/users"
        let parameters = [
            "username": username,
            "password": password
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "Votre compte a été créé", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { _ in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
}
