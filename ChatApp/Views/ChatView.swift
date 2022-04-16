//
//  ChatView.swift
//  ChatApp
//
//  Created by mac on 14/4/2022.
//

import SwiftUI




struct ChatView: View {
    
    
    @ObservedObject var  vm : ChatViewController
    
    var body: some View {
        messagesView
            .navigationTitle(vm.chatUser?.email ?? "")
            .navigationBarTitleDisplayMode(.inline)
            .onDisappear {
                vm.firestoreListener?.remove()
            }
    }
    
    private var messagesView: some View {
        ScrollView {
            ScrollViewReader{scrollViewProxy in
                
                VStack{
                    ForEach(vm.messages) { message in
                        MessageCard(message: message)
                    }
                    HStack{Spacer()}
                    .id("Empty")
                }.onReceive(vm.$count) { _ in
                    withAnimation (.easeOut(duration: 0.5)){
                        scrollViewProxy.scrollTo("Empty", anchor: .bottom)
                    }
                }
            }
        }
        .background(Color(.init(white: 0.95, alpha: 1)))
        .safeAreaInset(edge: .bottom) {
            chatBar.background(Color(.systemBackground).ignoresSafeArea())
        }
        
    }
    
    private var chatBar: some View {
        HStack(spacing: 16) {
            //            Image(systemName: "photo.on.rectangle")
            //                .font(.system(size: 24))
            //                .foregroundColor(Color(.darkGray))
            ZStack {
                DescriptionPlaceholder()
                TextEditor(text: $vm.chatText)
                    .opacity(vm.chatText.isEmpty ? 0.5 : 1)
                
            }
            .frame(height: 40)
            
            Button {
                self.vm.sned()
            } label: {
                Text("Send")
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}

private struct DescriptionPlaceholder: View {
    var body: some View {
        HStack {
            Text("Description")
                .foregroundColor(Color(.gray))
                .font(.system(size: 17))
                .padding(.leading, 5)
                .padding(.top, -4)
            Spacer()
        }
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
    }
}
