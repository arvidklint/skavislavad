//
//  ProfileViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-22.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var currentBalance: UILabel!
    
    @IBOutlet weak var addBalanceField: UITextField!

    
    @IBAction func addBalanceButton(sender: AnyObject) {
        var inputBalance : String = "0"
        if addBalanceField.text != ""{
            inputBalance = addBalanceField.text!
            let newbalance = Int(currentBalance.text!)! + Int(inputBalance)!
            currentBalance.text = String(newbalance)
            
            // UPPDATERAR SALDO
            Alamofire.request(.PUT, "http://localhost:3000/api/user/Emil", parameters : ["balance" : Int(inputBalance)!]).response { (request, response, data, error) in
                print("User balance has been updated.")
                print("New balance is: \(newbalance)")
            }
            addBalanceField.text = ""
        }

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let username = NSUserDefaults.standardUserDefaults().stringForKey("username") {
                Alamofire.request(.GET, "http://localhost:3000/api/user/\(username)").responseJSON { response in
            
                let json = JSON(response.result.value!)
                let user = ProfileUser(json: json)
                self.currentBalance.text = String(user.balance)
                self.profileName.text = user.username
            }
        } else {
            showMessage("Varning", message: "Hittade inte användaren")
        }
        
        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(sender: UIButton) {
        NSUserDefaults.standardUserDefaults().setObject(nil, forKey: "username")
        NSUserDefaults.standardUserDefaults().setObject(false, forKey: "userLoggedIn")
        self.performSegueWithIdentifier("Logout", sender: self)
    }
    
    func logoutHandler(alert: UIAlertAction!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func showMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
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
