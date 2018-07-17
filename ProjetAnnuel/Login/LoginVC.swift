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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let header: HTTPHeaders = ["Content-Type": "application/json"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.layer.cornerRadius = 25
        self.submitButton.layer.borderWidth = 1
        self.submitButton.layer.borderColor = UIColor.white.cgColor
        self.createAccountButton.layer.cornerRadius = 25
        self.createAccountButton.layer.borderWidth = 1
        self.createAccountButton.layer.borderColor = UIColor.white.cgColor
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if let username = self.usernameTextField.text, let password = self.passwordTextField.text, !username.isEmpty && !password.isEmpty {
            self.activityIndicator.startAnimating()
            self.requestLogin(username: username, password: password)
        } else {
            self.okAlert(title: "Erreur", message: "error_username_password".localized)
        }
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
                    self.requestGetProfile(token: token, username: username)
                }
                
            case .failure:
                self.activityIndicator.stopAnimating()
                if response.response?.statusCode == 404 {
                    self.okAlert(title: "Erreur", message: "Utilisateur non trouvé")
                } else if response.response?.statusCode == 403 {
                    self.okAlert(title: "Erreur", message: "Identifiants incorrects")
                } else if response.response == nil {
                    self.okAlert(title: "Erreur", message: "Aucune réponse du serveur")
                } else {
                    self.okAlert(title: "Erreur", message: "Erreur Auth \(String(describing: response.response?.statusCode))")
                }
            }
        })
    }
    
    func requestGetProfile(token: String, username: String) {
        let headerToken: HTTPHeaders = ["Content-Type": "application/json",
                                        "Authorization": token]
        
        let url = self.baseUrl + "/users/username/" + username
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<User>) in
            switch response.result {
            case .success:
                if let user = response.result.value {
                    if let id = user.id {
                        SessionManager.GetInstance().setId(id: id)
                    }
                    self.activityIndicator.stopAnimating()
                    let homeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Home") as! UINavigationController
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = homeVC
                    guard let window = UIApplication.shared.keyWindow else {
                        return
                    }
                    
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                        window.rootViewController = homeVC
                    }, completion: { _ in })
                }
                
            case .failure:
                self.activityIndicator.stopAnimating()
                self.okAlert(title: "Erreur", message: "Erreur Get Profile \(String(describing: response.response?.statusCode))")
            }
        })
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.passwordTextField.resignFirstResponder()
        self.usernameTextField.resignFirstResponder()
    }
}
