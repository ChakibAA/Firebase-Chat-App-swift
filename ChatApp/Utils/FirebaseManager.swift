//
//  FirebaseManager.swift
//  ChatApp
//
//  Created by mac on 9/4/2022.
//

import Foundation
import Firebase
import SwiftUI

class FirebaseManager : NSObject {
    
    let auth : Auth
    let storage:Storage
    let firestore : Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
