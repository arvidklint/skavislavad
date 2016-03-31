//
//  BetEventSummaryViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-29.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class BetEventSummaryViewController: UIViewController {
    
    
    var createdBet: BetEvent?

    @IBOutlet weak var summaryTitle: UILabel!
    @IBOutlet weak var summaryDesc: UITextView!
    @IBOutlet weak var summaryAmount: UILabel!
    @IBOutlet weak var successfulButton: UIButton!
    @IBOutlet weak var unsuccessfulButton: UIButton!
    
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultPreLabel: UILabel!
    @IBOutlet weak var resultPostLabel: UILabel!
    
    @IBAction func cancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion:{
            self.performSegueWithIdentifier("BackToList", sender: self)
        })
    }
    
    @IBAction func betSucceeded(sender: AnyObject) {
        print("Vadslagning lyckades!")
        /*Alamofire.request(.PUT, "http://localhost:3000/api/betvent/id/\(createdBet?.id)", parameters : ["successful" : true]).response { (request, response, data, error) in
            print("Bet \(self.summaryTitle) has ended.")
            print("The outcome was successful.")
        }*/
        
        let parameters = [
            "betId": createdBet!.id,
            "result": "yes"
        ]
        
        Alamofire.request(.PUT, "http://localhost:3000/api/finishedbets", parameters: parameters).responseJSON { response in
            let json = JSON(response.result.value!)
            if (json["status"].intValue == 0) {
                print("Fail")
            }
        }
        betEventFinished()
        resultPostLabel.text = "lyckades!"
    }
    
    @IBAction func betUnsuccessful(sender: AnyObject) {
        print("Vadslagning misslyckades!")
        /*Alamofire.request(.PUT, "http://localhost:3000/api/betvent/id/\(createdBet?.id)", parameters : ["successful" : false]).response { (request, response, data, error) in
            print("Bet \(self.summaryTitle) has ended.")
            print("The outcome was unsuccessful.")
        }*/
        
        let parameters = [
            "betId": createdBet!.id,
            "result": "no"
        ]
        
        Alamofire.request(.PUT, "http://localhost:3000/api/finishedbets", parameters: parameters).responseJSON { response in
            let json = JSON(response.result.value!)
            if (json["status"].intValue == 0) {
                print("Fail")
            }
        }
        betEventFinished()
        resultPostLabel.text = "misslyckades!"
    }
    
    func betEventFinished() {
        successfulButton.hidden = true
        unsuccessfulButton.hidden = true
        resultTitle.hidden = false
        resultPreLabel.hidden = false
        resultPostLabel.hidden = false
        if (createdBet!.result == "yes") {
            resultPostLabel.text = "lyckades"
        } else if (createdBet!.result == "no") {
            resultPostLabel.text = "misslyckades"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if (createdBet!.finished == true) {
            betEventFinished()
        } else {
            resultTitle.hidden = true
            resultPreLabel.hidden = true
            resultPostLabel.hidden = true
        }
        
        summaryTitle.text = createdBet!.title
        summaryDesc.text = createdBet!.desc
        summaryAmount.text = String(createdBet!.betAmount!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
