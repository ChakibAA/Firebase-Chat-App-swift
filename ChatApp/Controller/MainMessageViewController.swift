//
//  MainMessageController.swift
//  ChatApp
//
//  Created by mac on 11/4/2022.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class MainMessageViewController: ObservableObject {
    
    @Published var errorMessage = ""
    @Published var chatUser: ChatUser?
    @Published var userLoggedOut : Bool = false
    
    @Published var recentMessages  = [Message]()
    
    private var firestoreListener : ListenerRegistration?
    
    init(){
        
        DispatchQueue.main.async {
            self.userLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        fetchRecentMessage()
    }
    
    public func fetchRecentMessage(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            self.errorMessage = "you are not logged"
            return }
            firestoreListener?.remove()
        self.recentMessages.removeAll()
        
       firestoreListener = FirebaseManager.shared.firestore.collection("users").document(uid).collection("recent_messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let err = error {
                self.errorMessage = "\(err)"
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                
                let docId = change.document.documentID
                
                if let index = self.recentMessages.firstIndex(where: { rm in
                    return rm.id == docId
                }) {
                    self.recentMessages.remove(at: index)
                }
                
                
                
                if let rm = try? change.document.data(as: Message.self){
                    self.recentMessages.insert(rm, at: 0)
                }
                
            })
        }
    }
    
    
    public func handleSignOut(){
        userLoggedOut.toggle()
        firestoreListener?.remove()
        try?  FirebaseManager.shared.auth.signOut()
        
        
    }
    
    public func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{
            self.errorMessage = "you are not logged"
            return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument {  snapshot, error in
            if let error = error{
                
                self.errorMessage = "\(error)"
                
                
                print("failed \(error)")
                return
            }

            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            
            
        }
    }
}
