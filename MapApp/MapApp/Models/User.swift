//
//  User.swift
//  MapApp
//
//  Created by Fernando Moreira on 27/11/22.
//

import Foundation
import CoreLocation

class UserModel {
    
    internal init(id: String, email: String, imageProfile: String, lastLatitude: CLLocationDegrees, lastLongitude: CLLocationDegrees) {
        self.id = id
        self.email = email
        self.imageProfile = imageProfile
        self.lastLatitude = lastLatitude
        self.lastLongitude = lastLongitude
    }
    
    var id: String
    var email: String
    var imageProfile: String
    var lastLatitude: CLLocationDegrees
    var lastLongitude: CLLocationDegrees
    
}
