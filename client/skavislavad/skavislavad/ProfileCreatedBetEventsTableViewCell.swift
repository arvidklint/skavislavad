//
//  ProfileCreatedBetEventsTableViewCell.swift
//  skavislavad
//
//  Created by Emil Westin on 2016-03-24.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit

class ProfileCreatedBetEventsTableViewCell: UITableViewCell {
    @IBOutlet weak var createdBetName: UILabel!
    @IBOutlet weak var createdBetAmount: UILabel!
    @IBOutlet weak var createdBetParticipants: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
