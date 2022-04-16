//
//  NewMessagesView.swift
//  ChatApp
//
//  Created by mac on 13/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewMessagesView: View {
    
    let selectNewUser : (ChatUser) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = NewMessageViewController()
    
    var body: some View {
        NavigationView{
            ScrollView{
                if(vm.load){
                    ProgressView ()
                        .progressViewStyle(CircularProgressViewStyle())
                }else{
                    ForEach(vm.chatUsers){  user in
                        Button{
                            presentationMode.wrappedValue.dismiss()
                            selectNewUser(user)
                        } label:{
                            UserCard(user: user)
                        }
                    }
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button{
                            presentationMode.wrappedValue.dismiss()
                        } label:{
                            Text("Cancel")
                        }
                    }
                }
        }
    }
    
    
}

struct NewMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
