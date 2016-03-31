//
//  NewBetEventViewController.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 23/03/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NewBetEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleInput: UITextField!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var betAmountInput: UITextField!
    
    let username = NSUserDefaults.standardUserDefaults().stringForKey("username")
    var createdBet : BetEvent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleInput.delegate = self
        descriptionInput.delegate = self
        betAmountInput.delegate = self
        // Handle the text field’s user input through delegate callbacks.
        print("did load")
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        print("should return")
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("end editing")
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        print("begin editing")
    }
    
    // MARK: UITextViewdDelegate
    func textViewShouldReturn(textView: UITextView) -> Bool {
        // Hide the keyboard.
        textView.resignFirstResponder()
        print("text view should return")
        return true
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        print("text view end editing")
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        // Disable the Save button while editing.
        print("text view begin editing")
    }
    
    // MARK: Create new bet event
    @IBAction func createBetEvent(sender: UIButton) {
        print("Create Bet event")
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .Alert)
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
        let parameters = [
            "betName": self.titleInput.text,
            "userName": username,
            "betAmount": betAmountInput.text,
            "description": self.descriptionInput.text
        ]
        
        Alamofire.request(.POST, "http://localhost:3000/api/betevent", parameters: parameters)
            .responseJSON { response in
                // add betevent to return in backend.js
                let json = JSON(response.result.value!)
                if (json["status"].intValue == 1) {
                    print(json)
                    self.createdBet = BetEvent(json: json["message"])!
                    
                    self.titleInput.text = ""
                    self.descriptionInput.text = ""
                    self.betAmountInput.text = ""
                    
                    
                }
                self.dismissViewControllerAnimated(false, completion:{
                    self.performSegueWithIdentifier("summary", sender: self)
                })
            }
    }
    
    @IBAction func cancelNewBetEvent(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "summary" {
            let betEventSummary = segue.destinationViewController as! BetEventSummaryViewController
            
            betEventSummary.createdBet = self.createdBet
        }
    }
}
