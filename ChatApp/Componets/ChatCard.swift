//
//  ChatCard.swift
//  ChatApp
//
//  Created by mac on 9/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatCard: View {
    
    var msg : Message
    
    var body: some View {
        VStack{
            HStack(spacing : 16){
                WebImage(url: URL(string: msg.profileImageUrl!))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label), lineWidth: 2)
                    );                     VStack(alignment: .leading) {
                        Text(msg.email!.replacingOccurrences(of: "@gmail.com", with: "") )
                            .font(.system(size: 16, weight: .bold))
                        Text(msg.text)
                            .font(.system(size: 14))
                            .foregroundColor(Color(.lightGray))
                            .multilineTextAlignment(.leading)
                    }
                
                Spacer()
                
                Text(msg.timeAgo)
                .font(.system(size: 14,weight: .semibold))}
            
            
            Divider()
                .padding(.vertical,8)
        }.padding(.horizontal)
        
    }
}

struct ChatCard_Previews: PreviewProvider {
    static var previews: some View {
        MainMessagesView()
        //        ChatCard(msg: .init(documentId: "12", me: true, data: ["profileImageUrl":"https://firebasestorage.googleapis.com:443/v0/b/swift-chat-app-1a2de.appspot.com/o/zjVNeUyTPnX6cKrrt9n776ls6zo1?alt=media&token=c75fa833-9e78-4477-8fb1-16b6aae3b0ae","email" : "test","text":"test new message"]))
    }
}
