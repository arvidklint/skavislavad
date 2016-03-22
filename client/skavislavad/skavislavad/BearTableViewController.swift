//
//  BearTableViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 20/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire

class BearTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var bears = [String]()
    @IBOutlet weak var tableview: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem()
        
//        if let savedBears = loadBears() {
//            bears += savedBears
//        } else {
//            // Load the sample data.
//            loadSampleBears()
//        }
        
        Alamofire.request(.GET, "http://localhost:3000/api/bears") .responseJSON { response in // 1
            print(response.request)  // original URL request
            print(response.response) // URL response
            print(response.data)     // server data
            print(response.result)   // result of response serialization
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                for index in 0..<JSON.count {
                    print(JSON[index]["name"]!)
                    self.bears.append(JSON[index]["name"]! as! String)
                }
            }
            
            self.tableview.reloadData()
        }
    }
    
//    func loadSampleBears() {
//        let photo1 = UIImage(named: "sample1")!
//        let bear1 = Bear(name: "Arvid", photo: photo1, rating: 4)!
//        
//        let photo2 = UIImage(named: "sample1")!
//        let bear2 = Bear(name: "Emil Westin", photo: photo2, rating: 5)!
//        
//        let photo3 = UIImage(named: "sample1")!
//        let bear3 = Bear(name: "Mikael 2", photo: photo3, rating: 3)!
//        
//        bears += [bear1, bear2, bear3]
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bears.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "BearTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BearTableViewCell
        
        let bear = bears[indexPath.row]
        
        cell.nameLabel.text = bear
//        cell.photoImageView.image = bear.photo
//        cell.ratingControl.rating = bear.rating

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            bears.removeAtIndex(indexPath.row)
            saveBears()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "ShowBear" {
//            let bearDetailViewController = segue.destinationViewController as! BearViewController
//            // Get the cell that generated this segue.
//            if let selectedMealCell = sender as? BearTableViewCell {
//                let indexPath = tableView.indexPathForCell(selectedMealCell)!
//                let selectedBear = bears[indexPath.row]
//                bearDetailViewController.bear = selectedBear
//            }
//        }
//        else if segue.identifier == "AddBear" {
//            print("Adding new bear!")
//        }
    }

    
    @IBAction func unwindToBearList(sender: UIStoryboardSegue) {
//        if let sourceViewController = sender.sourceViewController as? BearViewController, bear = sourceViewController.bear {
//            
//            if let selectedIndexPath = tableView.indexPathForSelectedRow {
//                // Update an existing meal.
//                bears[selectedIndexPath.row] = bear
//                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
//            }
//            else {
//                // Add a new meal.
//                let newIndexPath = NSIndexPath(forRow: bears.count, inSection: 0)
//                bears.append(bear)
//                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
//            }
//            saveBears()
//        }
    }
    
    // MARK: NSCoding
    func saveBears() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(bears, toFile: Bear.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadBears() -> [Bear]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(Bear.ArchiveURL.path!) as? [Bear]
    }

}
