//
//  BetEvent.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 22/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class BetEvent {
    // MARK: Properties
    
    var title: String
    var desc: String
    var betAmount: Int?
    var username: String
    var id: String
    
    init?(json: JSON) {
        self.title = json["betName"].stringValue
        self.desc = json["description"].stringValue
        self.betAmount = json["betAmount"].intValue
        self.username = json["userName"].stringValue
        self.id = json["_id"].stringValue
        
        if (title.isEmpty || username.isEmpty) {
            //|| id.isEmpty) {
            return nil
        }
    }
}