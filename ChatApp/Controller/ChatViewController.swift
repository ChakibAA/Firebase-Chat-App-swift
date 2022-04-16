//
//  ChatViewController.swift
//  ChatApp
//
//  Created by mac on 15/4/2022.
//

import Foundation
import Firebase

class ChatViewController : ObservableObject {
    
    @Published var chatText = ""
    
    @Published var errorMessage = ""
    
    @Published var messages = [Message]()
    
    @Published var count = 0
    
    var firestoreListener : ListenerRegistration?
    
    var chatUser: ChatUser?
    
    init(chatUser : ChatUser?){
        self.chatUser = chatUser
        
        fetchMessages()
    }
    
    public func fetchMessages(){
        
        guard let fromId =  FirebaseManager.shared.auth.currentUser?.uid else {return }
        
        guard let toId =  chatUser?.uid else {return }
        
        
        firestoreListener?.remove()
        self.messages.removeAll()
        
        firestoreListener =  FirebaseManager.shared.firestore.collection("messages").document(fromId).collection(toId).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let err = error {
                self.errorMessage = "\(err)"
                return
            }
            
            querySnapshot?.documentChanges.forEach({ change in
                
                
                if change.type == .added {
                    if let rm = try? change.document.data(as: Message.self){
                        
                        self.messages.append(rm)
                    }
                }
            })
            
            DispatchQueue.main.async{
                self.count += 1
            }
            
            
        }
    }
    
    private func persistRecentMessage(){
        
        guard let uid =  FirebaseManager.shared.auth.currentUser?.uid else {return }
        
        guard let toId =  chatUser?.uid else {return }
        
        
        let fromDoc = FirebaseManager.shared.firestore
            .collection("users")
            .document(uid)
            .collection("recent_messages")
            .document(toId)
        
        
        
        let fromData = [
            "timestamp" : Timestamp(),
            "text" : self.chatText,
            "fromId":uid,
            "toId" : toId,
            "profileImageUrl" : chatUser!.profileImageUrl,
            "email" : chatUser!.email
            
        ] as [String : Any]
        
        fromDoc.setData(fromData) { error in
            if let err = error {
                self.errorMessage = "\(err)"
                return
            }
            
            guard let currentUser = FirebaseManager.shared.auth.currentUser else { return }
            
            let toDoc = FirebaseManager.shared.firestore
                .collection("users")
                .document(toId)
                .collection("recent_messages")
                .document(uid)
            
            let toData = [
                "timestamp" : Timestamp(),
                "text" : self.chatText,
                "fromId":uid,
                "toId" : toId,
                "profileImageUrl" : currentUser.photoURL?.absoluteString,
                "email" : currentUser.email
                
            ] as [String : Any]
            
            toDoc.setData(toData) { error in
                if let err = error {
                    self.errorMessage = "\(err)"
                    return
                }}
            
        }
        
        
    }
    
    public func sned(){
        
        if(self.chatText == ""){
            return
        }
        guard let fromId =  FirebaseManager.shared.auth.currentUser?.uid else {return }
        
        guard let toId =  chatUser?.uid else {return }
        
        let sendDoc =  FirebaseManager.shared.firestore
            .collection("messages")
            .document(fromId)
            .collection(toId)
            .document()
        
        let messageData = ["fromId" : fromId , "toId": toId,"text":self.chatText,"timestamp":Timestamp()] as [String : Any]
        
        sendDoc.setData(messageData){error in
            if let err = error {
                self.errorMessage = "\(err)"
                return
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recpDoc =  FirebaseManager.shared.firestore
            .collection("messages")
            .document(toId)
            .collection(fromId)
            .document()
        
        recpDoc.setData(messageData){error in
            if let err = error {
                self.errorMessage = "\(err)"
                return
            }
        }
    }
}
