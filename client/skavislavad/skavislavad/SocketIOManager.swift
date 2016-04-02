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
    
    func disconnectUser(username: String) {
        socket.emit("disconnectUser", username)
    }
    
//    func connectToServerWithUsername(username: String, completionHandler: (userList: [[String: AnyObject]]!) -> Void) {
//        socket.emit("connectUser", username)
//        
//        socket.on("SomeMessage") { (dataArray, ack) -> Void in
//            completionHandler(userList: dataArray[0] as! [[String: AnyObject]])
//        }
//    }
    
    func sendMessage(message: String, roomId id: String) {
        socket.emit("chatMessage", message, id)
        print("kom vi hit?")
    }
    
    func getMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.on("receiveMessage") { (dataArray, socketAck) -> Void in
            var messageDictionary = [String: AnyObject]()
            messageDictionary["username"] = dataArray[0]["from"] as! String
            messageDictionary["message"] = dataArray[0]["message"] as! String
            messageDictionary["date"] = dataArray[0]["date"] as! String
            
            completionHandler(messageInfo: messageDictionary)
        }
    }
    
//    func getMessage(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
//        socket.on("newMessage") { (dataArray, socketAck) -> Void in
//            var messageDictionary = [String: AnyObject]()
//            messageDictionary["username"] = dataArray[0] as! String
//            messageDictionary["message"] = dataArray[1] as! String
//            messageDictionary["date"] = dataArray[2] as! String
//            
//            completionHandler(messageInfo: messageDictionary)
//        }
//    }
    
    func getRoom(completionHandler: (messageInfo: [String: AnyObject]) -> Void) {
        socket.once("room") { (dataArray, socketAck) -> Void in
            print(dataArray)
            var room = [String: AnyObject]()
            room["roomId"] = dataArray[0]["roomId"] as! String
            room["members"] = dataArray[0]["members"] as! [String]
            
            completionHandler(messageInfo: room)
        }
    }
    
    func joinChatRoomWithId(roomId: String) {
        socket.emit("joinRoomWithId", roomId)
    }
    
    func joinChatRoomWithMembers(members: [String]) {
        socket.emit("joinChatRoomWithMembers", members)
    }
}
