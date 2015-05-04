//
//  SocialBank.swift
//  Social Wallet
//
//  Created by Mauricio de Oliveira on 5/2/15.
//  Copyright (c) 2015 SocialBanks. All rights reserved.
//

import UIKit

class SocialBank: NSObject {
    var name: String!
    var balance: Float!
    var isBitcoin: Bool!
    
    required init?(dictionary: NSDictionary) {
        super.init()
        
        if let value = dictionary["name"] as? String {
            self.name = value
        }
        else {
            return nil
        }
        
        if let value = dictionary["balance"] as? Float {
            self.balance = value
        }
        else {
            return nil
        }
        
        if let value = dictionary["isBitcoin"] as? Bool {
            self.isBitcoin = value
        }
        else {
            return nil
        }
        
    }
}
/*
class Usuario: NSObject, BaseModelProtocol {
    
    var nome: String!
    var email: String!
    var id: Int!
    
    required init?(dictionary: NSDictionary) {
        super.init()
        
        if let value = dictionary["id"] as? Int {
            self.id = value
        }
        else {
            return nil
        }
        
        if let value = dictionary["nome"] as? String {
            self.nome = value
        }
        else {
            return nil
        }
        
        if let value = dictionary["email"] as? String {
            self.email = value
        }
        else {
            return nil
        }
    }
    
    internal override var description : String {
        get {
            return "User(\(self.id)) - \(self.nome)|\(self.email)"
        }
    }
}
*/