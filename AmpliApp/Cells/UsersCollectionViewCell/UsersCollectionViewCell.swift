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
    @IBOutlet weak var userCountry: UILabel?
    @IBOutlet var viewLabel:UIView?

    override func awakeFromNib() {
        super.awakeFromNib()
        viewLabel?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
        
        // Initialization code
    }

}
