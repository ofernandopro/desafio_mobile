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

class HomeViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var counter = 0
    var idUser: String = ""
    var auth: Auth!
    var db: Firestore!
    
    var userLastLatitude: CLLocationDegrees?
    var userLastLongitude: CLLocationDegrees?
    
    private func handleIsAuthenticated() {
        if !AuthManager.shared.isSignedIn() { // User not signed In, show Login Screen
            let loginVC = LoginService().alert()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Change status bar to clear
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
        
        auth = Auth.auth()
        db = Firestore.firestore()
        
        self.getIdLoggedUser()
        
        self.handleIsAuthenticated()
        //self.navigationController?.isNavigationBarHidden = true
        
        map.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //self.deleteEntityData(entity: "User")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.getIdLoggedUser()
        
        print("idUser \(idUser)")
        
        let usersRef = self.db
          .collection("users")
        .document(idUser)
        
        usersRef.getDocument { (snapshot, error) in
            
            if let data = snapshot?.data() {
                
                
                let lastLatitude = data["lastLatitude"] as? CLLocationDegrees
                let lastLongitude = data["lastLongitude"] as? CLLocationDegrees
                
                
                if lastLatitude != nil && lastLongitude != nil {
                    let coordinates = CLLocationCoordinate2D(latitude: lastLatitude!, longitude: lastLongitude!)
                                        
                    //let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 1500, longitudinalMeters: 1500)
                    
                    Analytics.logEvent("map_rendering_success", parameters: ["lastLatitude": lastLatitude!, "lastLongitude": lastLongitude!])
                    
                    let mapCamera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 5000, pitch: 50, heading: 0)
                    self.map.setCamera(mapCamera, animated: true)
                    
                    //self.map.setRegion(region, animated: true)
                }
                
            }
        }
        
        
    }
    
    func getIdLoggedUser() {
        if let id = auth.currentUser?.uid {
            self.idUser = id
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
        //locationManager.stopUpdatingLocation()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.updateDB()
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
            
            
            if checkUserExistCoreData() {
                self.updateCoreData(lat: stLat, lon: stLon)
            } else {
                self.saveCoreData(lat: stLat, lon: stLon)
            }
        }
    }
    
    // Remove todas as instâncias do Core Data
    func deleteEntityData(entity : String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
    func saveCoreData(lat: String, lon: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        user.setValue(idUser, forKey: "id")
        user.setValue(lat, forKey: "lastLatitude")
        user.setValue(lon, forKey: "lastLongitude")
        
        do {
            try context.save()
        } catch {
            print("Erro salvar Core Data")
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.getDataFromCoreData()
    }
    
    func updateCoreData(lat: String, lon: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
                
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(req)
            
            if users.count > 0 {
                
                for user in users as! [NSManagedObject] {
                    if let userId = user.value(forKey: "id") as? String {
                        if userId == self.idUser {
                            
                            user.setValue(lat, forKey: "lastLatitude")
                            user.setValue(lon, forKey: "lastLongitude")
                            
                        }
                    }
                }
                
            }
        } catch {
            print("Erro ao recuperar do Core Data")
        }
        
        do {
            try context.save()
        } catch {
            print("Erro salvar Core Data")
        }
        
    }
    
    func checkUserExistCoreData() -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(req)
            
            if users.count > 0 {
                
                for user in users as! [NSManagedObject] {
                    if let userId = user.value(forKey: "id") as? String {
                        if userId == self.idUser {
                            return true
                        }
                    }
                }
                return false
                
            } else {
                return false
            }
        } catch {
            print("Erro ao recuperar do Core Data")
        }
        return false
    }
    
    func getDataFromCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(req)
            
            if users.count > 0 {
                
                for user in users as! [NSManagedObject] {
                    if let userId = user.value(forKey: "id") {
                        if let lastLatitude = user.value(forKey: "lastLatitude") {
                            if let lastLongitude = user.value(forKey: "lastLongitude") {
                                print("coredata userId \(userId)")
                                print("coredata lastLatitude \(lastLatitude)")
                                print("coredata lastLongitude \(lastLongitude)")
                            }
                        }
                    }
                }
                
            } else {
                print("Nenhum usuário encontrado")
            }
        } catch {
            print("Erro ao recuperar do Core Data")
        }
    }
    
    func center() {
        if let coordinates = locationManager.location?.coordinate {
            //let region = MKCoordinateRegion.init(center: coordinates, latitudinalMeters: 1500, longitudinalMeters: 1500)
            
            let mapCamera = MKMapCamera(lookingAtCenter: coordinates, fromDistance: 5000, pitch: 50, heading: 0)
            self.map.setCamera(mapCamera, animated: true)
            
            //self.map.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse && status != .notDetermined {
            
            presentAlertOpenConfig(title: "Permissão de localicação",
                                   message: "Para que você possa usar o aplicativo, precisamos da sua localização. Por favor, habilite.",
                                   title1: "Abrir Configurações",
                                   title2: "Cancelar")
            
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
