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
    var yesVotersArray = [Int]()
    var noVotersArray = [Int]()
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        betEvents = [BetEvent]()
        
        Alamofire.request(.GET, "http://localhost:3000/api/betevent/unfinished").responseJSON { response in
            
            let json = JSON(response.result.value!)
            print(json)
            for index in 0..<json["value"].count {
                self.betEvents.append(BetEvent(json: json["value"][index])!)
            }
            self.yesVotersArray = [Int](count: self.betEvents.count, repeatedValue:0)
            self.noVotersArray = [Int](count: self.betEvents.count, repeatedValue:0)
            for i in 0..<self.betEvents.count {
                Alamofire.request(.GET, "http://localhost:3000/api/betevent/votes/\(self.betEvents[i].id)").responseJSON { response in
                    print(response.result.value)
                    let json = JSON(response.result.value!)
                    let yesVoters = json["value"]["yesVoters"].count
                    let noVoters = json["value"]["noVoters"].count
                    self.yesVotersArray[i] = yesVoters
                    self.noVotersArray[i] = noVoters
                    
                    self.tableview.reloadData()
                }
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
        return betEvents.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BetFeedTableViewCell", forIndexPath: indexPath) as! BetFeedTableViewCell
        
        let betEvent = betEvents[indexPath.row]
        
        cell.betCellLabel.text = betEvent.title
        cell.betDescription.text = String(betEvent.desc)
        cell.betCellAmount.text = String(betEvent.betAmount!)
        cell.betCellThumbsUp.text = String(self.yesVotersArray[indexPath.row])
        cell.betCellThumbsDown.text = String(self.noVotersArray[indexPath.row])

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
