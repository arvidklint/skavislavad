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
        print(parameters)
        
        Alamofire.request(.POST, "http://localhost:3000/api/betevent", parameters: parameters)
            .responseJSON { response in
                let json = JSON(response.result.value!)
                print(json)
                
                self.titleInput.text = ""
                self.descriptionInput.text = ""
                self.betAmountInput.text = ""
                self.dismissViewControllerAnimated(false, completion: nil)
                
                // Close the view and go back to the list in some way.
            }
            .responseString { response in
                print("Response String: \(response.result.value)")
            }
    }
    
    @IBAction func cancelNewBetEvent(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
