//
//  ProfileAllBetEventsTableViewCell.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-28.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit

class ProfileAllBetEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var betEventTitle: UILabel!
    @IBOutlet weak var betEventCreator: UILabel!
    @IBOutlet weak var betEventAmount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
