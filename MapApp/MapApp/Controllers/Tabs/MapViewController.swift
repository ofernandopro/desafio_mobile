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
import CoreData
import FirebaseAnalytics

class MapViewController: UIViewController {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var idUser: String = ""
    var auth: Auth!
    var db: Firestore!
    
    var user = UserModel()
    var userLastLatitude: CLLocationDegrees?
    var userLastLongitude: CLLocationDegrees?
    
    private func handleIsAuthenticated() {
        if !AuthManager.shared.isSignedIn() { // User not signed In, show Login Screen
            let loginVC = LoginService().alert()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }
    
    func getIdLoggedUser() {
        if let id = auth.currentUser?.uid {
            self.idUser = id
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Change status bar to white
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        self.getIdLoggedUser()
        self.handleIsAuthenticated()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.getIdLoggedUser()
        
        if idUser != "" {
            map.delegate = self
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
                        
        let usersRef = self.db
          .collection("users")
        .document(idUser)
        
        usersRef.getDocument { (snapshot, error) in
            
            if let data = snapshot?.data() {
                
                let email = data["email"] as? String
                let imageProfile = data["imageURL"] as? String
                let lastLatitude = data["lastLatitude"] as? CLLocationDegrees
                let lastLongitude = data["lastLongitude"] as? CLLocationDegrees
                
                if lastLatitude != nil && lastLongitude != nil {
                    
                    self.user = UserModel(id: self.idUser, email: email ?? "", imageProfile: imageProfile ?? "", lastLatitude: lastLatitude!, lastLongitude: lastLongitude!)
                    
                    let coordinates = CLLocationCoordinate2D(latitude: lastLatitude!, longitude: lastLongitude!)
                                                            
                    Analytics.logEvent("map_rendering_success", parameters: ["lastLatitude": lastLatitude!, "lastLongitude": lastLongitude!])
                    
                    let mapCamera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 5000, pitch: 50, heading: 0)
                    self.map.setCamera(mapCamera, animated: true)
                    
                }
                
            }
        }
                
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        CoreData.getDataFromCoreData()
    }
    
    func updateDB() {
        if self.userLastLatitude != nil && self.userLastLongitude != nil {
            self.db
                .collection("users")
                .document(idUser)
                .updateData([
                    "lastLatitude": self.userLastLatitude!,
                    "lastLongitude": self.userLastLongitude!
                ])
                        
            //Send these latitude and longitude values to your firebase,
            let numLat = NSNumber(value: self.userLastLatitude! as Double)
            let stLat: String = numLat.stringValue
            let numLon = NSNumber(value: self.userLastLongitude! as Double)
            let stLon: String = numLon.stringValue
            
            if CoreData.checkUserExistCoreData(id: idUser) {
                CoreData.updateCoreData(id: idUser, lat: stLat, lon: stLon)
            } else {
                CoreData.saveCoreData(id: idUser, lat: stLat, lon: stLon)
            }
        }
    }
    
    func presentAlertOpenConfig(title: String, message: String, title1: String, title2: String) {

        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionConfig = UIAlertAction(title: title1, style: .default, handler: { (alertConfig) in
            
            if let configs = NSURL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(configs as URL)
            }
            
        })
        
        let actionCancel = UIAlertAction(title: title2, style: .default, handler: nil)
        
        alertController.addAction(actionConfig)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertLocationPermission(title: String, message: String, title1: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionOk = UIAlertAction(title: title1, style: .default, handler: nil)
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
    }

}

extension MapViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func center() {
        if let coordinates = locationManager.location?.coordinate {
            
            let mapCamera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 5000, pitch: 50, heading: 0)
            self.map.setCamera(mapCamera, animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.center()
        
        let authStat = CLLocationManager.authorizationStatus()
        
        if authStat == .denied || authStat == .restricted || authStat == .notDetermined {
            
            self.presentAlertLocationPermission(title: "Permissão de localicação",
                                           message: "Para que você possa usar o aplicativo, precisamos da sua localização. Por favor, habilite.",
                                           title1: "Ok")
            
        } else {
            
            if let location = locations.last {
                self.userLastLatitude = location.coordinate.latitude
                self.userLastLongitude = location.coordinate.longitude
                
                self.updateDB()
                
            }
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            self.presentAlertOpenConfig(title: "Permissão de localicação",
                                   message: "Para que você possa usar o aplicativo, precisamos da sua localização. Por favor, habilite.",
                                   title1: "Abrir Configurações",
                                   title2: "Cancelar")
            
        }
    }
    
}
