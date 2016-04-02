//
//  ProfileMessagesTableViewCell.swift
//  skavislavad
//
//  Created by Arvid Sätterkvist on 01/04/16.
//  Copyright © 2016 arvidsat. All rights reserved.
//

import UIKit

class ProfileMessagesTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
