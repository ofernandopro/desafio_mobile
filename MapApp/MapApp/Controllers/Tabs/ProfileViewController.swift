//
//  ProfileViewController.swift
//  MapApp
//
//  Created by Fernando Moreira on 25/11/22.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import FirebaseStorageUI
import CoreLocation

class ProfileViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var lastLatitudeLabel: UILabel!
    @IBOutlet weak var lastLongitudeLabel: UILabel!
    @IBOutlet weak var testCrashlyticsButton: UIButton!
    
    @IBAction func actionSignOutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed to sign out")
        }
        
        self.handleIsAuthenticated()
    }
    
    @IBAction func didTapChooseImage(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]
          let _ = numbers[1]
    }
    
    var auth: Auth!
    var storage: Storage!
    var db: Firestore!
    
    var imagePicker = UIImagePickerController()
    var idUser: String = ""
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testCrashlyticsButton.addTarget(self,
                                        action: #selector(self.crashButtonTapped(_:)),
                                        for: .touchUpInside)
        
        testCrashlyticsButton.layer.shadowOffset = CGSize(width: 1, height: 0)
        testCrashlyticsButton.layer.shadowOpacity = 0.5
        testCrashlyticsButton.layer.shadowColor = UIColor.lightGray.cgColor
        testCrashlyticsButton.layer.shadowRadius = 7
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Change status bar to white
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
        
        imagePicker.delegate = self

        auth = Auth.auth()
        storage = Storage.storage()
        db = Firestore.firestore()
        
        self.getIdLoggedUser()
        self.getUserData()
        
    }
    
    func getUserData() {
        
        let usersRef = self.db
          .collection("users")
        .document(idUser)
        
        usersRef.getDocument { (snapshot, error) in
            
            if let data = snapshot?.data() {
                
                let nameUser = data["name"] as? String
                let emailUser = data["email"] as? String
                
                self.nameLabel.text = nameUser
                self.emailLabel.text = emailUser
                
                if let lastLatitudeUser = data["lastLatitude"] as? CLLocationDegrees {
                    if let lastLongitudeUser = data["lastLongitude"] as? CLLocationDegrees {
                        
                        let numLat = NSNumber(value: lastLatitudeUser as Double)
                        let stLat: String = numLat.stringValue
                        let numLon = NSNumber(value: lastLongitudeUser as Double)
                        let stLon: String = numLon.stringValue
                        
                        self.lastLatitudeLabel.text = "Latitude: " + stLat
                        self.lastLongitudeLabel.text = "Longitude: " + stLon
                    }
                } else {
                    self.lastLatitudeLabel.text = "Latitude: -"
                    self.lastLongitudeLabel.text = "Longitude: -"
                }
                
                
                if let imageURL = data["imageURL"] as? String {
                    self.profileImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                } else {
                    self.profileImageView.image = UIImage(systemName: "person.circle.fill")
                }
                
            }
            
        }
        
    }
    
    func presentAlertErrorImage(title: String, message: String, title1: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let actionOk = UIAlertAction(title: title1, style: .default, handler: nil)
        alertController.addAction(actionOk)
        
        present(alertController, animated: true, completion: nil)
    }

}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Calls method to save image on Firebase
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageRecovered = info[
            UIImagePickerController.InfoKey.originalImage
        ] as! UIImage
        
        saveImageFirebase(imageRecovered: imageRecovered)
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func saveImageFirebase(imageRecovered: UIImage) {
        
        self.profileImageView.image = imageRecovered
        
        let images = storage
            .reference()
            .child("images")
        
        if let imageUpload = imageRecovered.jpegData(compressionQuality: 0.5) {
            if let loggedUser = auth.currentUser {
                let idUser = loggedUser.uid
                let imageName = "\(idUser).jpg"
                
                let fotoPerfilRef = images.child("profile").child(imageName)
                    fotoPerfilRef.putData(imageUpload, metadata: nil) { (metaData, error) in
                        if error == nil {
                            fotoPerfilRef.downloadURL { (url, error) in
                                if let urlImage = url?.absoluteString {
                                    self.db
                                      .collection("users")
                                    .document(idUser)
                                      .updateData([
                                          "imageURL": urlImage
                                      ])
                                }
                            }
                        } else {
                            self.presentAlertErrorImage(title: "Erro",
                                                        message: "Erro ao atualizar a foto de perfil. Tente novamente!",
                                                        title1: "Ok")
                        }
                }
            }
        }
    }
    
}
