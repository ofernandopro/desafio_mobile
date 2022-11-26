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

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBAction func actionSignOutButton(_ sender: Any) {
    
        do {
            try Auth.auth().signOut()
        } catch {
            print("Failed to sign out")
        }
        
        self.handleIsAuthenticated()
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        imagePicker.delegate = self

        auth = Auth.auth()
        storage = Storage.storage()
        db = Firestore.firestore()
        
        self.getIdLoggedUser()
        self.getUserData()
        
    }
    
    func getIdLoggedUser() {
        if let id = auth.currentUser?.uid {
            self.idUser = id
        }
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
                //self.emailLabel.text = emailUsuario
                
                if let imageURL = data["imageURL"] as? String {
                    self.profileImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
                }
                
            }
            
        }
        
    }
    
    @IBAction func didTapChooseImage(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Chama o método para salvar imagem no firebase ao finalizar
    // a escolha da imagem
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
                            print("Erroooo")
                            //self.exibirMensagem(titulo: "Erro", mensagem: "Erro ao atualizar a foto de perfil. Tente novamente!")
                        }
                }
            }
        }
    }

}
