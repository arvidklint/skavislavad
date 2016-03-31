//
//  ProfileCreatedBetEventsTableViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-24.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileCreatedBetEventsTableViewController: UITableViewController {

    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var tableview: UITableView!
    
    var createdBetEvents = [BetEvent]()
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        createdBetEvents = [BetEvent]()
        
        Alamofire.request(.GET, "http://localhost:3000/api/betevent/\(username!)").responseJSON { response in
            
            let json = JSON(response.result.value!)
            if (json["status"].intValue == 1) {
                print("Profile Bet events controller - Antal skapade bets: \(json["value"].count)")
                for index in 0..<json["value"].count {
                    self.createdBetEvents.append(BetEvent(json: json["value"][index])!)
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return createdBetEvents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileCreatedBetEventsTableViewCell", forIndexPath: indexPath) as! ProfileCreatedBetEventsTableViewCell
        
        let betEvent = createdBetEvents[indexPath.row]

        cell.ongoingBetLabel.hidden = true
        cell.finishedBetLabel.hidden = true
        cell.createdBetAmount.text = String(betEvent.betAmount!)
        cell.createdBetName.text = betEvent.title
        if (betEvent.finished) {
            cell.finishedBetLabel.hidden = false
        } else {
            cell.ongoingBetLabel.hidden = false
        }
        
        return cell
    }
    
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailedBetView", sender: self)
    }
    */

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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "detailedBetView" {
            let betEventSummary = segue.destinationViewController as! BetEventSummaryViewController
            
            if let selectedBetCell = sender as? ProfileCreatedBetEventsTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedBetCell)!
                let selectedBet = createdBetEvents[indexPath.row]
                betEventSummary.createdBet = selectedBet
            }
        }
    }
    

}
