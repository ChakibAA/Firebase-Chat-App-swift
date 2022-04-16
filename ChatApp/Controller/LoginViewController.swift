//
//  LoginController.swift
//  ChatApp
//
//  Created by mac on 15/4/2022.
//

import Foundation
import Firebase
import SDWebImageSwiftUI

class LoginViewController : ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoginMode = false
    @Published var loginStatusMessage = ""
    @Published var load = false
    
    let completeLogin : () -> ()
    
    @Published var shouldShowImagePicker = false
    
    
    @Published var image : UIImage?
    
    init(completeLogin : @escaping () -> ()){
        self.completeLogin = completeLogin
        
    }
    
    
    public func handleAction(){
        self.load = true
        if self.isLoginMode {
            loginUser()
        }else{
            createNewAccount()
        }
                self.load = false

    }
    
    private func loginUser(){
        FirebaseManager.shared.auth.signIn(withEmail: self.email, password: self.password) { result, error in
            if let err = error{
                print("Failed")
                self.loginStatusMessage = "\(err)"
                return
            }
            
            self.loginStatusMessage = "user logged : \(result?.user.uid ?? "")"
            
            self.completeLogin()
        }
    }
    
    private func createNewAccount(){
        
        if self.image == nil  {
            self.loginStatusMessage = "Select image"
            return
        }
        
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) { result, error in
            if let err = error{
                print("Failed")
                self.loginStatusMessage = "\(err)"
                return
            }
            
            self.loginStatusMessage = "user create : \(result?.user.uid ?? "")"
            
            
            
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to Storage: \(err)"
                return
            }
            
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                
                self.loginStatusMessage = "Successfully stored image with url: \(url?.absoluteString ?? "")"
                
                guard let url = url else{return}
                
                let changeRequest =  FirebaseManager.shared.auth.currentUser?.createProfileChangeRequest()
                
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges(completion: { error in
                    if let err = error {
                        self.loginStatusMessage = "\(err)"
                        return
                    }
                })
                
                self.storeUserInfo(url: url)
            }
        }
    }
    
    private func storeUserInfo(url:URL){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else{
            return
        }
        
        let userData = ["email":self.email,"uid":uid,"profileImageUrl" : url.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { error in
                if let err = error {
                    self.loginStatusMessage = "\(err)"
                    return
                }
                
                self.completeLogin()
            }
    }
}
