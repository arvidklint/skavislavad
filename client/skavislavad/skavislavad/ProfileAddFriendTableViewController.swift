//
//  ProfileAddFriendTableViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-30.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileAddFriendTableViewController: UITableViewController, UISearchResultsUpdating {

//    var allUsers = [ProfileUser]()
    var allUsers = [String]()
//    let tableData = ["One","Two","Three","Twenty-One"]
    var filteredUsers = [String]()
    var resultSearchController = UISearchController()
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Alamofire.request(.GET, "http://localhost:3000/api/getFoes/\(username!)").responseJSON { response in
            let json = JSON(response.result.value!)
            print(json)
            if (json["status"] == 1) {
                for index in 0..<json["value"].count {
                    // self.allUsers.append(ProfileUser(json: json["value"][index]))
                    self.allUsers.append(json["value"][index].stringValue)
                }
            }
            else {
                print(json["message"])
            }
            self.tableView.reloadData()
        }
        
        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        // Reload the table
        self.tableView.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        if (self.resultSearchController.active) {
            return self.filteredUsers.count
        }
        else {
            return self.allUsers.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileAddFriendTableViewCell", forIndexPath: indexPath) as! ProfileAddFriendTableViewCell
        
        // 3
        if (self.resultSearchController.active) {
            cell.textLabel?.text = filteredUsers[indexPath.row]
            
            return cell
        }
        else {
            cell.textLabel?.text = allUsers[indexPath.row]
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if (self.resultSearchController.active) {
            dismissViewControllerAnimated(false, completion: nil)

            print(filteredUsers[indexPath.row])
            let refreshAlert = UIAlertController(title: "Lägg till kompis", message: "Är du säker på att du vill ha \(allUsers[indexPath.row]) som kompis?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: { (action: UIAlertAction!) in
                Alamofire.request(.PUT, "http://localhost:3000/api/addFriend", parameters : ["userName": self.username!, "friendName": self.allUsers[indexPath.row]]).responseJSON { response in
                    let json = JSON(response.result.value!)
                    print(json)
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
            
        }
        else {
            print(allUsers[indexPath.row])
            
            let refreshAlert = UIAlertController(title: "Lägg till kompis", message: "Är du säker på att du vill ha \(allUsers[indexPath.row]) som kompis?", preferredStyle: UIAlertControllerStyle.Alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Ja", style: .Default, handler: { (action: UIAlertAction!) in
                Alamofire.request(.PUT, "http://localhost:3000/api/addFriend", parameters : ["userName": self.username!, "friendName": self.allUsers[indexPath.row]]).responseJSON { response in
                    let json = JSON(response.result.value!)
                    if(json["status"].intValue == 0){
                        print(json["message"].stringValue)
                    }
                    self.allUsers.removeAtIndex(indexPath.row)
                    self.tableView.reloadData()
                }
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "Avbryt", style: .Default, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            
            presentViewController(refreshAlert, animated: true, completion: nil)
        }
    }
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        filteredUsers.removeAll(keepCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (allUsers as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredUsers = array as! [String]
        
        self.tableView.reloadData()
    }
    

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
