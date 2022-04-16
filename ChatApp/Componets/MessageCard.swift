//
//  MessageCard.swift
//  ChatApp
//
//  Created by mac on 15/4/2022.
//

import SwiftUI

struct MessageCard: View {
    
    let message : Message

    var body: some View {
             VStack{
                    if (message.fromId == FirebaseManager.shared.auth.currentUser?.uid) {
                        HStack {
                            Spacer()
                            HStack {
                                Text(message.text)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                        }
                        
                    }else{
                        HStack {
                            
                            HStack {
                                Text(String(message.text))
                                
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            Spacer()
                        }
                        
                    }
                } .padding(.horizontal)
                    .padding(.top, 8)
    }
}

struct MessageCard_Previews: PreviewProvider {
    static var previews: some View {
//        MessageCard(Me)
    MainMessagesView()
    }
}
