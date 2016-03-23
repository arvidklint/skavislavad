//
//  ProfileUser.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-23.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class ProfileUser{
    // MARK: Properties
    
    var username: String
    //    var desc: String
    var password: String
    var balance: Int
    
    init(json: JSON){
        self.username = json["userName"].stringValue
        self.password = json["password"].stringValue
        self.balance = json["balance"].intValue
    }
    
    func getBalance() -> Int{
        return self.balance
    }
}