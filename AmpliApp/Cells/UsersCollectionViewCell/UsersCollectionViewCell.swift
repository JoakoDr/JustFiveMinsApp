//
//  UsersCollectionViewCell.swift
//  AmpliApp
//
//  Created by Dario Autric on 10/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit

class UsersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var userImg: UIImageView?
    @IBOutlet weak var userName: UILabel?
    @IBOutlet weak var userAge: UILabel?
    @IBOutlet weak var iconAdd: UIButton?
    @IBOutlet weak var iconSee: UIButton?
    @IBOutlet weak var iconChat: UIButton?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

}
