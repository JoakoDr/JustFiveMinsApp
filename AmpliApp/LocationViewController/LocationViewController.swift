//
//  LocationViewController.swift
//  AmpliApp
//
//  Created by Dario Autric on 10/5/19.
//  Copyright © 2019 Joaquin Diaz. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet var nextBtn:UIButton?
    var userLocation : Location?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    @IBAction func clickNext(_ sender: UIButton!) {
        setLocation()
        let usersVC = UsersViewController()
        navigationController?.pushViewController(usersVC, animated: false)
    }
    func setLocation()
    {
        var locationManager : CLLocationManager?
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager?.location else {
                print("Error al pillar lat y long")
                return
            }
            currentLocation.geocode { placemark, error in
                if let error = error as? CLError {
                    print("CLError:", error)
                    return
                } else if let placemark = placemark?.first {
                    // you should always update your UI in the main thread
                    DispatchQueue.main.async {
                        //  update UI here
                    
                        print("city:", placemark.locality ?? "unknown")
                        print("zip code:", placemark.postalCode ?? "unknown")
                        print("country:", placemark.country ?? "unknown", terminator: "\n\n")
                        self.userLocation = Location(sCity: placemark.locality!, sCountry: placemark.country!, sLong: currentLocation.coordinate.longitude, sLat: currentLocation.coordinate.latitude, sPostalCode: placemark.postalCode!)
                        FirebaseApiManager.sharedInstance.firestoreDB?.collection("users").document((FirebaseApiManager.sharedInstance.firUser?.uid)!).updateData(["location": self.userLocation?.getMap()])
                        { err in
                            if let err = err {
                                print("Error adding document: \(err)")
                            }
                            else
                            {
                                print("Has cargado tu location!")
                            }
                    }
                }
            }
        
        }
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
extension CLLocation {
    func geocode(completion: @escaping (_ placemark: [CLPlacemark]?, _ error: Error?) -> Void)  {
        CLGeocoder().reverseGeocodeLocation(self, completionHandler: completion)
    }
}
