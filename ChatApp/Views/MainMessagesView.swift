//
//  MainMessagesView.swift
//  ChatApp
//
//  Created by mac on 9/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI





struct MainMessagesView: View {
    
    @State var shouldSHowLogOutOption = false
    @State var navigateToChatView = false
    @State var newMessageScreen = false
    
    @State var chatUser : ChatUser?
    
    @ObservedObject private var vm = MainMessageViewController()
    
    private var chatViewController  = ChatViewController(chatUser: nil)
    
    var body: some View {
        NavigationView{
            VStack{
                customNavBar
                
                ScrollView{
                    ForEach(vm.recentMessages) { msg in
                        Button {
                            let uid = FirebaseManager.shared.auth.currentUser?.uid == msg.fromId ? msg.toId : msg.fromId
                            
                            self.chatUser = .init(id: uid, uid: uid, email: msg.email ?? "", profileImageUrl: msg.profileImageUrl ?? "")
                            
                            self.chatViewController.chatUser = self.chatUser
                            self.chatViewController.fetchMessages()
                            self.navigateToChatView.toggle()
                            
                        } label : {
                            ChatCard(msg: msg)
                        }.foregroundColor(Color(.label))
                    }.padding(.bottom,50)
                    
                }
                
                if self.chatUser != nil {
                    NavigationLink("", isActive: $navigateToChatView) {
                        ChatView(vm: chatViewController)
                    }
                }
                
            }.overlay(
                newMessageButton,alignment: .bottom
            ).navigationBarHidden(true)
        }
    }
    
    private var customNavBar : some View {
        HStack{
            WebImage(url:URL(string: vm.chatUser?.profileImageUrl ?? ""))
                .resizable()
                .scaledToFill()
                .frame(width : 50,height:50)
                .clipped()
                .cornerRadius(50)
                .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label),lineWidth: 0.5))
                .shadow(radius: 5)
            
            VStack(alignment:.leading,spacing: 4){
                let name = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                
                Text(name)
                    .font(.system(size:24,weight: .bold))
                HStack{
                    Circle().foregroundColor(.green).frame(width:14,height: 14)
                    Text("online").font(.system(size:12)).foregroundColor(Color(.lightGray))
                }
            }
            
            Spacer()
            
            Button{
                shouldSHowLogOutOption.toggle()
            }label:{
                Image(systemName: "gear").font(.system(size:24,weight: .bold))
            }.foregroundColor(Color(.label))
            
        }.padding()
            .actionSheet(isPresented: $shouldSHowLogOutOption) {
                .init(title: Text("Settings"), message: Text("What do you want to do?"), buttons: [
                    .destructive(Text("Sign Out"), action: {
                        vm.handleSignOut()
                    }),
                    .cancel()
                ])
            }
            .fullScreenCover(isPresented: $vm.userLoggedOut, onDismiss: nil) {
                LoginView(completeLogin : {
                    self.vm.userLoggedOut = false
                    self.vm.fetchCurrentUser()
                    self.vm.fetchRecentMessage()
                    
                    
                })
            }
    }
    
    
    private var newMessageButton : some View{
        Button{
            newMessageScreen.toggle()
        }
    label:{
        HStack{
            Spacer()
            Text("+ New Message")
                .font(.system(size : 16,weight:.bold))
            
            Spacer()
            
        }.foregroundColor(.white)
            .padding(.vertical)
            .background(.blue)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 15)
        
    }.fullScreenCover(isPresented: $newMessageScreen, onDismiss: nil) {
        NewMessagesView(selectNewUser: { user in
            self.chatUser = user
            self.chatViewController.chatUser = user
            self.chatViewController.fetchMessages()
            self.navigateToChatView.toggle()
            
        })
    }
    }
}

struct MainMessagesView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
