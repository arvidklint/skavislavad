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
            Alamofire.request(.PUT, "http://localhost:3000/api/user/Emil", parameters : ["balance" : newbalance]).response { (request, response, data, error) in
                print("User balance has been updated.")
                print("New balance is: \(newbalance)")
            }
            addBalanceField.text = ""
        }

        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewn har laddat")
        
        // Do any additional setup after loading the view.
        
        Alamofire.request(.GET, "http://localhost:3000/api/user/Emil").responseJSON { response in
            
            let json = JSON(response.result.value!)
            let user = ProfileUser(json: json)
            print(user.getBalance())
            self.currentBalance.text = String(user.balance)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
