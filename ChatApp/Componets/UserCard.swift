//
//  UserCard.swift
//  ChatApp
//
//  Created by mac on 15/4/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCard: View {
    
    let user : ChatUser
    
    var body: some View {
        VStack{
            HStack(spacing : 16){
                WebImage(url: URL(string: user.profileImageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipped()
                    .cornerRadius(50)
                    .overlay(RoundedRectangle(cornerRadius: 50)
                                .stroke(Color(.label), lineWidth: 2)
                    )
                
                Text(user.email) .font(.system(size: 16,weight: .bold))
                    .foregroundColor(Color(.label))
                Spacer()
            }
            Divider()
                .padding(.vertical,8)
        }.padding(.horizontal)
    }
}

struct UserCard_Previews: PreviewProvider {
    static var previews: some View {
        //        UserCard()
        MainMessagesView()
    }
}
