//
//  ChatRoom.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 02/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import Foundation

class ChatRoom {
    
    var members: [String]!
    var roomId: String!
    
    init?(members: [String], roomId: String) {
        self.members = members
        self.roomId = roomId
        
        if members.isEmpty || roomId.isEmpty {
            return nil
        }
    }
}
