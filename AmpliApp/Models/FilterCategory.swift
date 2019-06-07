//
//  FilterCategory.swift
//  AmpliApp
//
//  Created by Dario Autric on 7/6/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import Foundation
enum CategoryFilterType: String {
    case country = "United States"
    case city = "San Francisco"
    case postalcode = "94108"
    case randomusers = "LOL"
    case job = "Programador"
    case university = "U-tad"
}
import Foundation
class FilterCategory {
    var categoryTitle : String?
    var categoryImg : String?
    var arrUsers : [Profile] = []
    
    convenience init (categoryTitle: String,categoryImg: String, arrUsers: [Profile])
    {
        self.init()
        self.categoryTitle = categoryTitle
        self.categoryImg = categoryImg
        self.arrUsers = arrUsers
        
    }
}
