//
//  ChatRoomViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 02/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ChatRoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    var messages: [Message] = [Message]()
    var chatRoom: ChatRoom?
    
    @IBOutlet weak var messageInput: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        configureTableView()
        
        print("http://localhost:3000/api/getmessages/\(chatRoom!.roomId)")
        
        Alamofire.request(.GET, "http://localhost:3000/api/getmessages/\(chatRoom!.roomId)").responseJSON { response in
            
            let json = JSON(response.result.value!)
            print(json)
            if (json["status"].intValue == 1) {
                for index in 0 ..< json["value"].count {
                    let messageString = json["value"][index]["message"].stringValue
                    let sender = json["value"][index]["userName"].stringValue
                    let message = Message(message: messageString, roomId: (self.chatRoom?.roomId)!, username: sender)
                    self.messages.append(message!)
                }
                self.tableview.reloadData()
            } else {
                print(json["message"])
            }
        }
        
        SocketIOManager.sharedInstance.getMessage { (messageInfo) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print(messageInfo)
//                self.messages.append(messageInfo)
//                self.tableview.reloadData()
                //                self.scrollToBottom()
            })
        }
        
//        dummyMessages()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        scrollToBottom()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Custom Methods
    
    func configureTableView() {
        tableview.delegate = self
        tableview.dataSource = self
//        tableview.registerNib(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "idCellChat")
//        tableview.estimatedRowHeight = 90.0
//        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.tableFooterView = UIView(frame: CGRectZero)
    }
    
    func dummyMessages() {
        let message1 = Message(message: "Test1", roomId: "kjdfaicniiaid38d39na9cn", username: "arvidsat")
        let message2 = Message(message: "Test2 fdjsaflkd falösdfjsadf ladjf ödlfnaskd clasdnfsaldfönasd cljsanfkl sadlfnasdlf lsd fl sadjf sdaöf jsdaj fjas dfök sadjfk asjf jsa fjlsda fljsd fl", roomId: "kjdfaicniiaid38d39na9cn", username: "arvidsat")
        let message3 = Message(message: "Test3", roomId: "kjdfaicniiaid38d39na9cn", username: "arvidsat")
        let message4 = Message(message: "Test4", roomId: "kjdfaicniiaid38d39na9cn", username: "Emil")
        let message5 = Message(message: "Test5", roomId: "kjdfaicniiaid38d39na9cn", username: "arvidsat")
        let message6 = Message(message: "Test6", roomId: "kjdfaicniiaid38d39na9cn", username: "Rasmus")
        
        messages = [message1!, message2!, message3!, message4!, message5!, message6!]
    }
    
    // MARK: UITableView Delegate and Datasource Methods
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        
        cell.message.text = messages[indexPath.row].message
        cell.message.sizeToFit()
        cell.usernameLabel.text = messages[indexPath.row].username
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
//        let height:CGFloat = self.calculateHeightForString(messages[indexPath.row].message)
        return 70.0
    }
//
//    func calculateHeightForString(inString:String) -> CGFloat
//    {
//        let messageString = inString
//        let attributes = [UIFont() as String: UIFont.systemFontOfSize(15.0)]
//        let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes)
//        let rect:CGRect = attrString!.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
//        let requredSize:CGRect = rect
//        return requredSize.height  //to include button's in your tableview
//        
//    }
    
    func scrollToBottom() {
        let delay = 0.1 * Double(NSEC_PER_SEC)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay)), dispatch_get_main_queue()) { () -> Void in
            if self.messages.count > 0 {
                let lastRowIndexPath = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
                self.tableview.scrollToRowAtIndexPath(lastRowIndexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    // MARK: UITextViewDelegate Methods
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // Actions
    @IBAction func send(sender: UIButton) {
        let messageToSend = messageInput.text;
        if messageToSend == "" {
            print("Inget att skicka")
        } else {
            let newMessage = Message(message: messageToSend!, roomId: chatRoom!.roomId, username: username!)
            messages.append(newMessage!)
            tableview.reloadData()
            SocketIOManager.sharedInstance.sendMessage((newMessage?.message)!, roomId: newMessage!.roomId)
            messageInput.text = ""
            
            // Skicka meddelande till servern
        }
        scrollToBottom()
    }
}
