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

class MapViewController: UIViewController, CLLocationManagerDelegate,Api,UIGestureRecognizerDelegate,MKMapViewDelegate {
    
    @IBOutlet var mapa:MKMapView?
    @IBOutlet var viewLabel:UIView?
    var locationManager:CLLocationManager?
    var boolLocMan:Bool?
    var arLocations:[CLLocationCoordinate2D?] = []
    var locationInView:CGPoint? = nil
    var locationOnMap:CLLocationCoordinate2D? = nil
    var annotation = MKPointAnnotation()
    let btnSave = UIButton(type: .custom)
    let btnClose = UIButton(type: .custom)
    let alert:UIAlertController = UIAlertController(title: "Location Updated", message: "¡Location Updated!", preferredStyle: UIAlertControllerStyle.actionSheet)
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        setupUserLocation()
        downloadFriends()
        mapa!.delegate = self
        floatingButton()
        print(self.arLocations.count)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
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
    func floatingButton(){
        
        //Floating button save
        btnSave.frame = CGRect(x: 300, y: 600, width: 50, height: 50)
        btnSave.setImage(UIImage(named: "save") , for: .normal)
        btnSave.backgroundColor = UIColor(hexString: "#41AEF6")
        btnSave.contentVerticalAlignment = .fill
        btnSave.contentHorizontalAlignment = .fill
        btnSave.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        btnSave.clipsToBounds = true
        btnSave.layer.cornerRadius = 25
        btnSave.layer.borderColor = UIColor.clear.cgColor
        btnSave.layer.borderWidth = 3.0
        btnSave.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        btnSave.layer.shadowRadius = 2.0
        btnSave.layer.shadowOpacity = 1.0
        btnSave.layer.masksToBounds = false
        btnSave.addTarget(self,action: #selector(MapViewController.saveTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(btnSave)
        
        
        btnClose.frame = CGRect(x: 220, y: 600, width: 50, height: 50)
        btnClose.setImage(UIImage(named: "back") , for: .normal)
        btnClose.backgroundColor = UIColor(hexString: "#941100")
        btnClose.clipsToBounds = true
        btnClose.layer.cornerRadius = 25
        btnClose.layer.borderColor = UIColor.clear.cgColor
        btnClose.layer.borderWidth = 3.0
        btnClose.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        btnClose.layer.shadowRadius = 2.0
        btnClose.layer.shadowOpacity = 1.0
        btnClose.layer.masksToBounds = false
        btnClose.addTarget(self,action: #selector(MapViewController.backTapped), for: UIControlEvents.touchUpInside)
        view.addSubview(btnClose)
        
        viewLabel?.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)
    }
    func downloadFriends()
    {
        FirebaseApiManager.sharedInstance.getUserData(delegate: self)
    }
    @objc func backTapped()   {
        let usersVC = UsersViewController()
        navigationController?.pushViewController(usersVC, animated: false)
    }
    @objc func saveTapped()   {
        showSpinner(onView: self.view)
        FirebaseApiManager.sharedInstance.setLocation(delegate: self)
       // FirebaseApiManager.sharedInstance.miPerfil.sLocation?.sLat = locationOnMap?.latitude
       // FirebaseApiManager.sharedInstance.miPerfil.sLocation?.sLong = locationOnMap?.longitude
       // FirebaseApiManager.sharedInstance.setLocation(delegate: self)
    }
    func updateLocation(blFinLocation: Bool) {
        if blFinLocation {
            
            print("TRUE")
            removeSpinner()
            let usersVC = UsersViewController()
            navigationController?.pushViewController(usersVC, animated: false)
            self.present(self.alert, animated: true)
            
        }
        else
        {
            
            self.present(self.alert, animated: true)
            removeSpinner()
        }
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
        
        let visRect = mapa?.visibleMapRect
        let inRectAnnotations = mapa?.annotations(in: visRect!)
            print("long tap")
            if sender.state == .changed {
                
                self.locationInView = sender.location(in: mapa)
                self.locationOnMap = mapa!.convert(locationInView!, toCoordinateFrom: mapa)
                
                //self.annotation.removeAnnotations(mapa.annotation)

                for anno : MKAnnotation in (mapa?.annotations)! {
                    if ((inRectAnnotations?.contains(anno as! AnyHashable))!) {
                        if let annotation = annotation as? MKAnnotation {
                            self.mapa?.removeAnnotation(annotation)
                        }
                        
                    }
                }
                addAnnotation(location: self.locationOnMap!)
     }
        //addAnnotation(location: self.locationOnMap!)
    }
    func addAnnotation(location: CLLocationCoordinate2D){
         self.annotation = MKPointAnnotation()
        self.annotation.coordinate = location
        self.annotation.title = "My Location"
        self.annotation.subtitle = "Me"
        self.mapa!.addAnnotation(annotation)
        
    }
}
    
extension MapViewController{
    
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
