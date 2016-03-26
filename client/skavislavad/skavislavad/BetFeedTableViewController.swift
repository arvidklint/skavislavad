//
//  BetFeedTableViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 22/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BetFeedTableViewController: UITableViewController {

    var betEvents = [BetEvent]()
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        Alamofire.request(.GET, "http://localhost:3000/api/betevent").responseJSON { response in
            
            let json = JSON(response.result.value!)
            print(json)
            for index in 0..<json.count {
                self.betEvents.append(BetEvent(json: json[index])!)
            }

            self.tableview.reloadData()
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
        return betEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BetFeedTableViewCell", forIndexPath: indexPath) as! BetFeedTableViewCell
        
        let betEvent = betEvents[indexPath.row]
        cell.betCellLabel.text = betEvent.title
        cell.betDescription.text = String(betEvent.desc);
        print(cell.betDescription.text)

        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("YO")
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowBetEvent" {
            let betEventDetailController = segue.destinationViewController as! BetEventViewController
            
            if let selectedBetCell = sender as? BetFeedTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedBetCell)!
                let selectedBet = betEvents[indexPath.row]
                betEventDetailController.bet = selectedBet
            }
        }
    }
    
    // MARK: Actions
    @IBAction func newBetEvent(sender: UIBarButtonItem) {
        let userLoggedIn = NSUserDefaults.standardUserDefaults().boolForKey("userLoggedIn")
        
        if userLoggedIn {
            self.performSegueWithIdentifier("NewBetEvent", sender: self)
        } 
    }
    

}
