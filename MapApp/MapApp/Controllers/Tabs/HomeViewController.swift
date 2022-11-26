//
//  ViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var counter = 0
    var idUser: String = ""
    var auth: Auth!
    var db: Firestore!
    
    private func handleIsAuthenticated() {
        if !AuthManager.shared.isSignedIn() { // User not signed In, show Login Screen
            let loginVC = LoginService().alert()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        self.getIdLoggedUser()
        
        self.handleIsAuthenticated()
        self.navigationController?.isNavigationBarHidden = true
        
        map.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

    }
    
    func getIdLoggedUser() {
        if let id = auth.currentUser?.uid {
            self.idUser = id
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //if counter < 3 {
            self.center()
            //counter += 1
        //} else {
            
        //}
        
        let authStat = CLLocationManager.authorizationStatus()
        
        if authStat == .denied || authStat == .restricted || authStat == .notDetermined {
            // alert
            let alertController = UIAlertController(title: "Permissão de localicação",
                                                    message: "Para que você possa usar o aplicativo, precisamos da sua localização. Por favor, habilite.",
                                                    preferredStyle: .alert)
            let actionOk = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(actionOk)
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            
            if let location = locations.last {
                let userLatitude = location.coordinate.latitude
                let userLongitude = location.coordinate.longitude
                
                self.db
                    .collection("users")
                    .document(idUser)
                    .updateData([
                        "lastLatitude": userLatitude,
                        "lastLongitude": userLongitude
                    ])
                
                //Send these latitude and longitude values to your firebase,
                //so you will have the user's location.
                
            }
            
        }
        //locationManager.stopUpdatingLocation()
        
        
        
    }
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    */
    func center() {
        if let coordinates = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 400, longitudinalMeters: 400)
            map.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            // alert
            let alertController = UIAlertController(title: "Permissão de localicação",
                                                    message: "Para que você possa usar o aplicativo, precisamos da sua localização. Por favor, habilite.",
                                                    preferredStyle: .alert)
            let actionConfig = UIAlertAction(title: "Abrir Configurações", style: .default, handler: { (alertConfig) in
                
                if let configs = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(configs as URL)
                }
                
            })
            
            let actionCancel = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alertController.addAction(actionConfig)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }

}
