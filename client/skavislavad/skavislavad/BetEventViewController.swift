//
//  BetEventViewController.swift
//  
//
//  Created by Arvid Sätterkvist on 26/03/16.
//
//

import UIKit

class BetEventViewController: UIViewController {
    
    @IBOutlet weak var betTitle: UILabel!
    @IBOutlet weak var betDescription: UITextView!
    
    var bet: BetEvent?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        betTitle.text = bet?.title;
        betDescription.text = bet?.desc;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yes(sender: UIButton) {
        print("yes")
    }
    
    @IBAction func no(sender: UIButton) {
        print("no")
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
