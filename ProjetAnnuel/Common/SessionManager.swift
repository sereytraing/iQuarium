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
    let id: String = "id"
    let defaults = UserDefaults.standard
    
    func setToken(token: String) {
        defaults.set(token, forKey: self.token)
    }
  
    func getToken() -> String? {
        return defaults.string(forKey: self.token)
    }
    
    func setId(id: String) {
        defaults.set(id, forKey: self.id)
    }
    
    func getId() -> String? {
        return defaults.string(forKey: self.id)
    }

    func flush() {
        defaults.removeObject(forKey: self.token)
        defaults.removeObject(forKey: self.id)
    }
}
