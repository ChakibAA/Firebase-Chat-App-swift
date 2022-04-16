//
//  NewMessageController.swift
//  ChatApp
//
//  Created by mac on 13/4/2022.
//

import Foundation

class NewMessageViewController : ObservableObject{
    
    @Published var errorMessage = ""
    @Published var chatUsers : [ChatUser] = []
    @Published var load = true
    
    init(){
        fetchUsers()
    }
    
    public func fetchUsers(){
        FirebaseManager.shared.firestore.collection("users").getDocuments{ documentSnapshot , error in
            if let err = error {
                self.errorMessage = "\(err)"
                self.load = false
                return
            }
            
            documentSnapshot?.documents.forEach({ snapshot in
                let user = try? snapshot.data(as: ChatUser.self)
                    if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                        self.chatUsers.append(user!)
                    }
            })
            self.load = false
        }
    }
}
