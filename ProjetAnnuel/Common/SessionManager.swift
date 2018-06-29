//
//  SessionManager.swift
//  ProjetAnnuel
//
//  Created by TRAING Serey on 29/06/2018.
//  Copyright © 2018 AlkRox. All rights reserved.
//

import Foundation

public class SessionManager {
    static func GetInstance() -> SessionManager {
        if instance == nil {
            instance = SessionManager()
        }
        return instance!
    }
    
    static var instance:SessionManager?
    
    let token: String = "token"
    let defaults = UserDefaults.standard
    
    func setToken(token: String) {
        defaults.set(token, forKey: self.token)
    }
  
    func getToken() -> String? {
        return defaults.string(forKey: self.token)
    }

    func flush() {
        defaults.removeObject(forKey: self.token)
    }
}
