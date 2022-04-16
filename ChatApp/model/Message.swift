//
//  Message.swift
//  ChatApp
//
//  Created by mac on 15/4/2022.
//


import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Message : Codable,Identifiable{
    
    @DocumentID var id: String?
    let fromId, toId , text : String
    let email , profileImageUrl : String?
    let timestamp : Date
    
    var timeAgo : String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
}
