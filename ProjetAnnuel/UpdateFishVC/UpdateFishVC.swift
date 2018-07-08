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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func requestUpdateFish() {
        let url = self.baseUrl + "/fishes/" + "idFish"
        let parameters = [
            "name": "",
            "height": ""
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headerToken).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<Aquarium>) in
            
            if response.response?.statusCode == 401 {
                self.logOut()
            } else {
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Ajout d'un poisson réussi", preferredStyle: UIAlertControllerStyle.alert)
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
