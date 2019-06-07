//
//  Location.swift
//  AmpliApp
//
//  Created by Dario Autric on 26/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import Foundation
import UIKit
// esta clase representa la localizacion del usuario actual descargandolo de la base de datos
class Location: NSObject {
    
    //hay que poner todos los datos del registro
    
    var sCity:String?
    var sCountry:String?
    var sLong:Double?
    var sLat:Double?
    var sPostalCode:String?
    init(sCity:String,sCountry:String,sLong:Double,sLat:Double,sPostalCode: String) {
        self.sCity = sCity
        self.sCountry = sCountry
        self.sLong = sLong
        self.sLat = sLat
        self.sPostalCode = sPostalCode
    }
    // pasamos el hashmap descargado de la base de datos a las variables
    
    func setMap(valores:[String:Any]){
        sCity = valores["city"] as? String
        sCountry = valores["country"] as? String
        sLong = valores["lng"] as? Double
        sLat = valores["lat"] as? Double
        sPostalCode = valores["postalCode"] as? String
    }
    // este metodo convierte a hashmap los datos para guardarlos en la base de datos
    func getMap() -> [String:Any] {
        
        return [
            "city": sCity as Any,
            "country": sCountry as Any,
            "lat": sLat as Any,
            "lng": sLong as Any,
            "postalCode": sPostalCode as Any
        ]
    }
    
}
