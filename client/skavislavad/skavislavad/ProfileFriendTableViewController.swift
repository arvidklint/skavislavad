//
//  ProfileFriendTableViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-30.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileFriendTableViewController: UITableViewController {

    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    var friendsArray = [String]()
    
    @IBAction func addFriend(sender: AnyObject) {
        
    }
    
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        friendsArray = [String]()
        Alamofire.request(.GET, "http://localhost:3000/api/getFriends/\(username!)").responseJSON  { response in
            let json = JSON(response.result.value!)
            
            for index in 0..<json["value"].count {
                // self.allUsers.append(ProfileUser(json: json["value"][index]))
                self.friendsArray.append(json["value"][index].stringValue)
            }
            self.tableView.reloadData()
            
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
        return self.friendsArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileFriendTableViewCell", forIndexPath: indexPath) as! ProfileFriendTableViewCell

        cell.friendName.text = friendsArray[indexPath.row]
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let parameters = [
                "userName": username!,
                "friendName": friendsArray[indexPath.row]
            ]

            Alamofire.request(.PUT, "http://localhost:3000/api/deleteFriend", parameters : parameters).responseJSON { response in
                let json = JSON(response.result.value!)
                if( json["status"].intValue == 0){
                    print("could not delete friend.")
                }
                else{
                    print("delete successful!")
                    self.friendsArray.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                self.tableView.reloadData()
            }
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
