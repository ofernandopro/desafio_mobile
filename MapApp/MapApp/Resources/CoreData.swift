//
//  CoreData.swift
//  MapApp
//
//  Created by Fernando Moreira on 01/12/22.
//

import UIKit
import CoreData
import MapKit

class CoreData {
    
    static func saveCoreData(id: String, lat: String, lon: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context)
        
        user.setValue(id, forKey: "id")
        user.setValue(lat, forKey: "lastLatitude")
        user.setValue(lon, forKey: "lastLongitude")
        
        do {
            try context.save()
        } catch {
            print("Erro salvar Core Data")
        }
        
    }
    
    static func updateCoreData(id: String, lat: String, lon: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
                
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(req)
            
            if users.count > 0 {
                
                for user in users as! [NSManagedObject] {
                    if let userId = user.value(forKey: "id") as? String {
                        if userId == id {
                            
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
    
    static func checkUserExistCoreData(id: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let req = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        do {
            let users = try context.fetch(req)
            
            if users.count > 0 {
                
                for user in users as! [NSManagedObject] {
                    if let userId = user.value(forKey: "id") as? String {
                        if userId == id {
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
    
    static func getDataFromCoreData() {
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
    
}
