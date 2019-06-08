//
//  Profile.swift
//  AmpliApp
//
//  Created by Dario Autric on 26/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import Foundation
import UIKit
// esta clase representa el perfil del usuario actual descargandolo de la base de datos
class Profile: NSObject {
    
    //hay que poner todos los datos del registro
    var sId:String?
    var sBirthday:String?
    var sEmail:String?
    var sName:String?
    var sSurname:String?
    var sGender:String?
    var sLocation:Location?
    var sJob:String?
    var sUniversity:String?
    var sDescription:String?
    
    
    
    func checkDataMap() -> Bool {
        print("está vacio")
        return sName != nil && sLocation?.sLat != nil && sLocation?.sLong != nil
    }
    // pasamos el hashmap descargado de la base de datos a las variables
    
    func setMap(valores:[String:Any]){
        sBirthday = valores["birthday"] as? String
        sJob = valores["job"] as? String
        sUniversity = valores["university"] as? String
        sDescription = valores["description"] as? String
        sGender = valores["gender"] as? String
        sName = valores["name"] as? String
        sEmail = valores["email"] as? String
        sSurname = valores["surname"] as? String
        sLocation = valores["location"] as? Location
    }
    // este metodo convierte a hashmap los datos para guardarlos en la base de datos
    func getMap() -> [String:Any] {
        
        return [
            "birthday": sBirthday as Any,
            "name": sName as Any,
            "email": sEmail as Any,
            "surname": sSurname as Any,
            "location": sLocation as Any,
            "gender": sGender as Any,
            "university": sUniversity as Any,
            "description": sDescription as Any,
            "job": sJob as Any
        ]
    }
    
}
