//
//  ProfileViewController.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-22.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var currentBalanceLabel: UILabel!
    @IBOutlet weak var balancePicker: UIPickerView!
    
    let pickerData = ["0", "1" ,"2" ,"3" ,"500", "1000"]
    
    @IBAction func addToBalance(sender: AnyObject) {
        balancePicker.hidden = false
        print("knappen är tryckt!")
        //currentBalanceLabel.text = "1500"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewn har laddat")
    
        // Do any additional setup after loading the view.
        balancePicker.delegate = self
        balancePicker.dataSource = self
        balancePicker.hidden = true
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
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        // Do something
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let tempBalance : Int? = Int(currentBalanceLabel.text!)
        let newBalance : Int? = tempBalance! + Int(pickerData[row])!
        currentBalanceLabel.text = String(newBalance!)
    }

}
