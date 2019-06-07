//
//  FirebaseApiManager.swift
//  AmpliApp
//
//  Created by Joaquin Diaz on 25/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import FirebaseMessaging


class FirebaseApiManager: NSObject {
    //objeto Manager para compartir la informacion desde todas las demas clases
    static let sharedInstance:FirebaseApiManager = FirebaseApiManager()
    var firDataBasRef: DatabaseReference!
    var firestoreDB:Firestore?
    var firStorage:Storage?
    var firStorageRef:StorageReference?
    var arUsers:[Profile] = []
    var filterJob:FilterCategory?
    var filterUniversity:FilterCategory?
    var filterCountry:FilterCategory?
    var filterPostalCode:FilterCategory?
    var filterCity:FilterCategory?
    var filterRandom:FilterCategory?
    var miPerfil:Profile = Profile()
    var firUser:User?
    var arFilters:[FilterCategory] = []
    var categorySelected : FilterCategory?
    var isFilter:Bool?
    var indexFilter:Int?
    var indexUser:Int?
    var arrFilterCategory:[FilterCategory] = []
    
    
    
    func initFirebase() {
        FirebaseApp.configure()
        firestoreDB=Firestore.firestore()
        firStorage = Storage.storage()
        firStorageRef = firStorage?.reference()
        setCategoryData()
        
    }
 
    // metodo que descarga todos los datos del perfil y los mete en arrciudads.
    func getUserData(delegate:Api) {
        
        var blFin:Bool = false
        
        FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                delegate.getUserDataApi!(blFin: false)
                
            } else {
                self.arUsers = []
                for document in querySnapshot!.documents {
                    let user:Profile = Profile()
                    user.sId=document.documentID
                    user.setMap(valores: document.data())
                    self.arUsers.append(user)
                    print("\(document.documentID) => \(document.data())")
                }
                
                //Introduzco los valores en el array de cada filtro(Job,University)
                for user in self.arUsers {
                    if user.sJob == CategoryFilterType.job.rawValue{
                        self.filterJob?.arrUsers.append(user)
                    }
                    if user.sLocation?.sCity == CategoryFilterType.city.rawValue{
                        self.filterCity?.arrUsers.append(user)
                    }
                    if user.sUniversity == CategoryFilterType.university.rawValue{
                        self.filterUniversity?.arrUsers.append(user)
                    }
                    if user.sLocation?.sPostalCode == CategoryFilterType.job.rawValue{
                        self.filterPostalCode?.arrUsers.append(user)
                    }
                    if user.sLocation?.sCountry == CategoryFilterType.job.rawValue{
                        self.filterCountry?.arrUsers.append(user)
                    }
                    if user.sGender == CategoryFilterType.job.rawValue{
                        self.filterRandom?.arrUsers.append(user)
                    }
                    
                }
                self.arrFilterCategory.append(self.filterJob!)
                self.arrFilterCategory.append(self.filterUniversity!)
                self.arrFilterCategory.append(self.filterCity!)
                self.arrFilterCategory.append(self.filterPostalCode!)
                self.arrFilterCategory.append(self.filterCountry!)
                self.arrFilterCategory.append(self.filterRandom!)
                print(self.filterCity?.arrUsers.count)
                print(self.filterCountry?.arrUsers.count)
                delegate.getUserDataApi!(blFin: true)
            }
            
        }
        
    }
    internal func isFiltered(user: Profile?) -> Bool{
        if let userSelected = user {
            if let index = indexFilter {
                //FirebaseApiManager.sharedInstance.arrFilterCollection[index].filter.contains(where: {$0.name})
                isFilter = arrFilterCategory[index].arrUsers.contains(where: {$0.sJob == user?.sJob})
                
            }
        }
        
        return isFilter ?? false
    }
    // metodo que sirve para registrarse
    func registrarse(email: String, password:String ,delegate: Api){
        // var blFinRegistro:Bool = false
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if (error == nil) {
                    if (authResult?.user != nil) {
                        FirebaseApiManager.sharedInstance.firUser = authResult?.user
                            print("Te Registraste !")
                            print(FirebaseApiManager.sharedInstance.miPerfil.getMap())
                            print(FirebaseApiManager.sharedInstance.firUser?.uid)
    FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").document((FirebaseApiManager.sharedInstance.firUser?.uid)!).setData(FirebaseApiManager.sharedInstance.miPerfil.getMap())
                                { err in
                                if let err = err {
                            print("Error adding document: \(err)")
                                    }
                        else
                        {
                        print("Has cargado tu data con el ID:")
                        }
                    }
                delegate.createUserApi!(blFinRegistro: true)
            }else
            {
                print(error!)
                
            }
            
        }
        
    }
    }
    // guardamos los datos del objeto perfil en forma de hashmap en la coleccion perfiles.
    func savePerfil() {
        
            print(self.miPerfil.sEmail)
            print(FirebaseApiManager.sharedInstance.firUser?.uid)
            print(self.miPerfil.sDescription)
        FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").document((FirebaseApiManager.sharedInstance.firUser?.uid)!).updateData(FirebaseApiManager.sharedInstance.miPerfil.getMap())
        { err in
            if let err = err {
                print("Error adding document: \(err)")
            }
            else
            {
                print("Has editado tu perfil")
            }
        }
       
    }
    func setCategoryData()  {
        self.filterCountry = FilterCategory(categoryTitle: "Country", categoryImg: "", arrUsers: [])
        self.filterCity = FilterCategory(categoryTitle: "City", categoryImg: "", arrUsers: [])
        self.filterPostalCode = FilterCategory(categoryTitle: "Postal Code", categoryImg: "", arrUsers: [])
        self.filterRandom = FilterCategory(categoryTitle: "Random Users", categoryImg: "", arrUsers: [])
        self.filterJob = FilterCategory(categoryTitle: "Job", categoryImg: "", arrUsers: [])
        self.filterUniversity = FilterCategory(categoryTitle: "University", categoryImg: "", arrUsers: [])
        arFilters = [self.filterCountry,self.filterCity,self.filterPostalCode,self.filterRandom,self.filterJob,self.filterUniversity] as! [FilterCategory]
        categorySelected = arFilters[0]
    }
    // metodo de login
    func login(email: String, password: String, delegate: Api){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if (error == nil) {
                
                if(email != nil && password != nil){
                    self.firUser = Auth.auth().currentUser
                    let refperfiles = FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").document((user?.user.uid)!)
                    refperfiles?.getDocument { (document, error) in
                        if document != nil {
                            print(document?.documentID as Any)
                            FirebaseApiManager.sharedInstance.miPerfil.setMap(valores: (document?.data())!)
                            print(document?.data()! as Any)
                            
                            delegate.loginUserApi!(blFinLogin: true)
                        } else {
                            print("Document does not exist")
                            delegate.loginUserApi!(blFinLogin: false)
                        }
                    }
                    print("Te Logeaste !")
                }
            }else
            {
                delegate.loginUserApi!(blFinLogin: false)
                //present(alert5, animated: true)
                print("error!")
                
            }
        }
    }
 
}
@objc protocol Api{
    
    @objc optional func getUserDataApi(blFin:Bool)
    @objc optional func createUserApi(blFinRegistro:Bool)
    @objc optional func loginUserApi(blFinLogin:Bool)
}
