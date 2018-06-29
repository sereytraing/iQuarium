//
//  LoginVC.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 22/04/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class LoginVC: DefaultVC {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    let header: HTTPHeaders = ["Content-Type": "application/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.white.cgColor
        self.createAccountButton.layer.cornerRadius = 25
        self.createAccountButton.layer.borderWidth = 1
        self.createAccountButton.layer.borderColor = UIColor.white.cgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text, !username.isEmpty && !password.isEmpty {
            self.requestLogin(username: username, password: password)
        } else {
            self.okAlert(title: "Erreur", message: "insert_username".localized)
        }
    }
    @IBAction func createAccountClicked(_ sender: Any) {
    }
    
    func requestLogin(username: String, password: String) {
        let url = self.baseUrl + "/auth/login"
        let parameters = [
            "username": username,
            "password": password
            ] as [String : Any]
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseString(completionHandler: { (response) in
           
            switch response.result {
            case .success:
                if let token = response.result.value {
                    SessionManager.GetInstance().setToken(token: token)
                }
                let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as! UINavigationController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = homeVC
                guard let window = UIApplication.shared.keyWindow else {
                    return
                }
                
                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = homeVC
                }, completion: { _ in })
            case .failure:
                self.okAlert(title: "Erreur", message: "Erreur \(String(describing: response.response?.statusCode))")
            }
        })
        
    }
}
