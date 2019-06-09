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

class MapViewController: UIViewController, CLLocationManagerDelegate,Api,UIGestureRecognizerDelegate {
    
    @IBOutlet var btnSalir:UIButton?
    @IBOutlet var mapa:MKMapView?
    var locationManager:CLLocationManager?
    var boolLocMan:Bool?
    var arLocations:[CLLocationCoordinate2D?] = []
    var locationInView:CGPoint? = nil
    var locationOnMap:CLLocationCoordinate2D? = nil
    var annotation = MKPointAnnotation()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserLocation()
        downloadFriends()
        mapa!.delegate = self
        print(self.arLocations.count)
       
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapa!.addGestureRecognizer(longTapGesture)
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
    print(FirebaseApiManager.sharedInstance.arUsers[0].sLocation?.sLat)
    if(blFin)
    {
    for user in FirebaseApiManager.sharedInstance.arUsers{
        if user.checkDataMap() {
            print("Esta Vacio" )
        }else {
             
       // addMapFriends(latitude: (user.sLocation?.sLat)!, longitude: (user.sLocation?.sLong)!, titulo: user.sName!)
        }
        
                                            }
        print("me he descargado mapa")
    } else {
        print("error")
            }
        }
    @objc func longTap(sender: UIGestureRecognizer){
        arLocations = []
        if(self.arLocations.count == 1 || self.arLocations.count == 0)
        {
            print("long tap")
            if sender.state == .changed {
                
                self.locationInView = sender.location(in: mapa)
                self.locationOnMap = mapa!.convert(locationInView!, toCoordinateFrom: mapa)
                addAnnotation(location: self.locationOnMap!)
                arLocations.append(self.locationOnMap)
            }
            
        }else {
        addAnnotation(location: self.locationOnMap!)
    }
    }
    func addAnnotation(location: CLLocationCoordinate2D){
         self.annotation = MKPointAnnotation()
        self.annotation.coordinate = location
        self.annotation.title = "Yo"
        self.annotation.subtitle = "Dedo Gordo"
        self.mapa!.addAnnotation(annotation)
        //self.arLocations.append(Location(sCity: "España", sCountry: "España", sLong: annotation.coordinate.longitude, sLat: annotation.coordinate.latitude, sPostalCode: "28005"))
        
    }
}
    
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, view annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { print("no mkpointannotaions"); return nil }
        
        
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView == nil
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = false
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
            pinView!.pinTintColor = UIColor.black
        }
        else {
            pinView!.annotation = annotation
            
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("tapped on pin ")
    }
    
    
}
