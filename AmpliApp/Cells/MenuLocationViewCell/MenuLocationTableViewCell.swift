//
//  MenuLocationTableViewCell.swift
//  AmpliApp
//
//  Created by Dario Autric on 17/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit

class MenuLocationTableViewCell: UITableViewCell {
    @IBOutlet weak var username: UILabel?
    @IBOutlet weak var locationButton: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
