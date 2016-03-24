//
//  Balance.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-24.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class Balance{
    // MARK: Properties
    
    var username: String
    var newBalance: Int
    var changedAmount: Int
    var balanceChange: String
    
    init(json: JSON){
        func getDateOfChange(dateString : String) -> String{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let date = dateFormatter.dateFromString(dateString)
            
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = .ShortStyle
            
            let formattedDate = String(dateFormatter.stringFromDate(date!))
            
            return formattedDate
        }
        
        self.username = json["userName"].stringValue
        self.newBalance = json["newBalance"].intValue
        self.changedAmount = json["changedAmount"].intValue
        self.balanceChange = getDateOfChange(json["balanceChange"].stringValue)
    }
    
    func getTotalBalance() -> Int{
        return self.newBalance
    }
    
    func getChangedAmount() -> Int{
        return self.changedAmount
    }
    
    
}
