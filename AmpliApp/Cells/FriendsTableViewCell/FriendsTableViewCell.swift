//
//  FriendsTableViewCell.swift
//  AmpliApp
//
//  Created by Dario Autric on 12/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var iconButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        userName?.text = "Joaquin Diaz"
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
