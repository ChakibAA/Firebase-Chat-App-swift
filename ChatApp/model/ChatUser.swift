//
//  ChatUser.swift
//  ChatApp
//
//  Created by mac on 11/4/2022.
//

import Foundation
import FirebaseFirestoreSwift


struct ChatUser : Codable,Identifiable{
    
    @DocumentID var id: String?
    let uid, email, profileImageUrl: String
    
}
