//
//  Message.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 02/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import Foundation

class Message {
    
    var message: String = ""
    var username: String = ""
    
    init?(message: String, username: String) {
        self.message = message
        self.username = username
        
        if message.isEmpty || username.isEmpty {
            return nil
        }
    }
}