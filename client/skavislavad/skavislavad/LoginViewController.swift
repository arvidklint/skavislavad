//
//  LoginViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 26/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func alertMessage(message: String) {
        let alert = UIAlertController(title: "Öh!", message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        
        alert.addAction(okAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func login(sender: UIButton) {
        let username = usernameInput.text
        
        if username!.isEmpty {
            alertMessage("Ange användarnamn")
        } else {
            Alamofire.request(.GET, "http://localhost:3000/api/login/\(username!)").responseJSON { response in
                let json = JSON(response.result.value!)
                print(json)
                
                if json["status"].intValue == 1 {
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "userLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.performSegueWithIdentifier("Login", sender: self)
                    
                } else if json["status"].intValue == 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alertMessage(json["message"].stringValue)
                    }
                }
            }
        }
    }
    
    @IBAction func register(sender: UIButton) {
        let username = usernameInput.text
        print(username)
        
        if username!.isEmpty {
            alertMessage("Ange användarnamn")
        } else {
            let parameters = [
                "userName": username!
            ]
            
            Alamofire.request(.POST, "http://localhost:3000/api/register", parameters: parameters).responseJSON { response in
                let json = JSON(response.result.value!)
                print(json)
                
                if json["status"].intValue == 1 {
                    NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
                    NSUserDefaults.standardUserDefaults().setObject(true, forKey: "userLoggedIn")
                    NSUserDefaults.standardUserDefaults().synchronize()
                    self.performSegueWithIdentifier("Login", sender: self)
                    
                } else if json["status"].intValue == 0 {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.alertMessage(json["message"].stringValue)
                    }
                }
            }
        }
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
