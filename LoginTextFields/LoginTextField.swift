//
//  LoginTextField.swift
//  AmpliApp
//
//  Created by Dario Autric on 9/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
open class LoginTextField: UITextField {
    func roundAndColor()
    {
     let border = CALayer()
        border.borderColor = UIColor.purple.cgColor
        border.cornerRadius = 5.0
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundAndColor()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        roundAndColor()
    }
}
