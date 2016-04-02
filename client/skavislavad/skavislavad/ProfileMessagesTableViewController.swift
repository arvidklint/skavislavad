//
//  ProfileMessagesTableViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 01/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileMessagesTableViewController: UITableViewController {
    
    @IBOutlet var tableview: UITableView!
    
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    var chatRooms = [ChatRoom]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        chatRooms = [ChatRoom]()
        
        Alamofire.request(.GET, "http://localhost:3000/api/getrooms/\(username!)").responseJSON { response in
            
            let json = JSON(response.result.value!)
            print(json)
            if (json["status"].intValue == 1) {
                for index in 0 ..< json["value"].count {
                    let chatRoom = ChatRoom(members: json["value"][index]["members"].arrayObject as! [String], roomId: json["value"][index]["roomId"].stringValue)
                    self.chatRooms.append(chatRoom!)
                }
                self.tableview.reloadData()
            } else {
                print(json["message"])
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatRooms.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatRoomCell", forIndexPath: indexPath) as! ProfileMessagesTableViewCell
        
        var namesString = ""
        var first = true
        for name in chatRooms[indexPath.row].members {
            if first {
                first = false
            } else {
                namesString += ", "
            }
            namesString += name
        }
        cell.usernameLabel.text = namesString;

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("ShowChatRoom", sender: self)
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChatRoom" {
            print("Segue to Chat room")
            let chatRoomController = segue.destinationViewController as! ChatRoomViewController
            if let selectedChatRoomCell = sender as? ProfileMessagesTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedChatRoomCell)!
                let selectedChatRoom = chatRooms[indexPath.row]
                chatRoomController.chatRoom = selectedChatRoom
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    // MARK: Actions
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
