//
//  BetEventViewController.swift
//  
//
//  Created by Arvid Sätterkvist on 26/03/16.
//
//

import UIKit
import Alamofire
import SwiftyJSON

class BetEventViewController: UIViewController {
    
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var betDescription: UITextView!
    @IBOutlet weak var betStatus: UILabel!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    
    var bet: BetEvent?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        betTitle.text = bet?.title;
        betDescription.text = bet?.desc;
        
        yesButton.enabled = false
        noButton.enabled = false
        self.betStatus.text = "Laddar status..."
        
        
        
        
        
        
        // Check if already placed a bet.
        Alamofire.request(.GET, "http://localhost:3000/api/placedbets?userName=\(username!)&betId=\(bet!.id)").responseJSON { response in
            let json = JSON(response.result.value!)
            print(json)
            
            if json["status"].intValue == 1 {
                self.yesButton.enabled = false
                self.noButton.enabled = false
                if json["value"][0]["type"].stringValue == "yes" {
                    self.betStatus.text = "Du tror på den här vadslagningen"
                } else {
                    self.betStatus.text = "Du tror inte på den här vadslagningen"
                }
            } else if json["status"].intValue == 0 {
                print("Fritt fram")
                self.betStatus.text = "Vad tror du?"
                self.yesButton.enabled = true
                self.noButton.enabled = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func yes(sender: UIButton) {
        
        yesButton.enabled = false
        noButton.enabled = false
        
        let parameters = [
            "userName": username!,
            "betId": bet!.id,
            "type": "yes"
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/placedbets", parameters: parameters).responseJSON { response in
            let json = JSON(response.result.value!)
            print(json)
            
            if json["status"].intValue == 1 {
                self.yesButton.enabled = false
                self.noButton.enabled = false
                self.betStatus.text = "Du tror på den här vadslagningen"
            } else if json["status"].intValue == 0 {
                self.alertMessage("Det gick inte att slå vad vid detta tillfälle")
                self.yesButton.enabled = true
                self.noButton.enabled = true
            }
        }
    }
    
    @IBAction func no(sender: UIButton) {
        yesButton.enabled = false
        noButton.enabled = false
        
        let parameters = [
            "userName": username!,
            "betId": bet!.id,
            "type": "no"
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/placedbets", parameters: parameters).responseJSON { response in
            let json = JSON(response.result.value!)
            print(json)
            
            if json["status"].intValue == 1 {
                self.yesButton.enabled = false
                self.noButton.enabled = false
                self.betStatus.text = "Du tror inte på den här vadslagningen"
            } else if json["status"].intValue == 0 {
                self.alertMessage("Det gick inte att slå vad vid detta tillfälle")
                self.yesButton.enabled = true
                self.noButton.enabled = true
            }
        }

    }
    
    // MARK: util
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Öh!", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
