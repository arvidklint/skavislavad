//
//  SocketIOManager.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 01/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://localhost:3000")!)
    
    override init() {
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func connectToServerWithUsername(username: String) {
        socket.emit("connectUser", username)
    }
    
//    func connectToServerWithUsername(username: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
//        socket.emit("connectUser", username)
//        
//        socket.on("SomeMessage") { (dataArray, ack) -> Void in
//            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
//        }
//    }
    
    func sendMessage(message: String, withUsername username: String) {
        socket.emit("chatMessage", username, message)
    }
    
    func getMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("newMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["username"] = dataArray[0] as! String
            messageDictionary["message"] = dataArray[1] as! String
            messageDictionary["date"] = dataArray[2] as! String
            
            completionHandler(messageInfo: messageDictionary)
        }
    }
}
