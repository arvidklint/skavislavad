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
    var roomId: String = ""
    var username: String = ""
    
    init?(message: String, roomId: String, username: String) {
        self.message = message
        self.roomId = roomId
        self.username = username
        
        if message.isEmpty || roomId.isEmpty || username.isEmpty {
            return nil
        }
    }
}