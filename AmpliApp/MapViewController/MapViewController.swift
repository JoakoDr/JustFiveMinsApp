//
//  MapViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 2/6/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate,Api,UIGestureRecognizerDelegate {
    
    @IBOutlet var btnSalir:UIButton?
    @IBOutlet var mapa:MKMapView?
    var locationManager:CLLocationManager?
    var boolLocMan:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserLocation()
        downloadFriends()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func setupUserLocation()
    {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        locationManager?.startUpdatingLocation()
        mapa?.showsUserLocation = true
    }
    func downloadFriends()
    {
        FirebaseApiManager.sharedInstance.getUserData(delegate: self)
    }
    func addMapFriends(latitude lat:Double, longitude lon:Double, titulo tpin:String)
    {
        let annotation:MKPointAnnotation = MKPointAnnotation()
        annotation.coordinate.latitude = lat
        annotation.coordinate.longitude = lon
        annotation.title = tpin
        mapa?.addAnnotation(annotation)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //el booleano siempre que entras es falso para que establezca en tu localización.
        if(boolLocMan == false){
            let miSpan:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let tempRegion:MKCoordinateRegion = MKCoordinateRegion(center: locations[0].coordinate, span: miSpan)
            mapa?.setRegion(tempRegion, animated: false)
            boolLocMan = true
        }
        
    }
    func getUserDataApi(blFin: Bool) {
    
    if(blFin)
    {
    for user in FirebaseApiManager.sharedInstance.arUsers {
        if(user.sLocation?.sLat! == nil || user.sLocation?.sLong! == nil || user.sName == nil){
            print("Esta Vacio" )
        }else {
        addMapFriends(latitude: (user.sLocation?.sLat!)!, longitude: (user.sLocation?.sLong!)!, titulo: user.sName!)
        }
        
                                            }
        print("me he descargado mapa")
    } else {
        print("error")
            }
        }

    }

