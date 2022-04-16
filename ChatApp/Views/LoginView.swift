//
//  Login.swift
//  ChatApp
//
//  Created by mac on 7/4/2022.
//

import SwiftUI
import Firebase




struct LoginView: View {
    
    let completeLogin : () -> ()
    
    @ObservedObject  var vm : LoginViewController
    
    init(completeLogin :  @escaping () -> ()){
        self.completeLogin = completeLogin
        self.vm = .init(completeLogin: completeLogin)
    }
    
    
    var body: some View {
        NavigationView {
            ZStack{
                if(vm.load){
                    ProgressView ()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                ScrollView {
                    
                    VStack(spacing: 16) {
                        Picker(selection: $vm.isLoginMode, label: Text("Picker here")) {
                            Text("Login")
                                .tag(true)
                            Text("Create Account")
                                .tag(false)
                        }.pickerStyle(SegmentedPickerStyle())
                        
                        if !vm.isLoginMode {
                            Button {
                                vm.shouldShowImagePicker.toggle()
                            } label: {
                                
                                VStack {
                                    if let image = vm.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 128, height: 128)
                                            .cornerRadius(64)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .padding()
                                            .foregroundColor(Color(.label))
                                    }
                                }
                                .overlay(RoundedRectangle(cornerRadius: 64)
                                            .stroke(Color.black, lineWidth: 3)
                                )
                                
                            }
                        }
                        
                        Group {
                            TextField("Email", text: $vm.email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                            SecureField("Password", text: $vm.password)
                        }
                        .padding(12)
                        .background(Color.white)
                        
                        Button {
                            vm.handleAction()
                        } label: {
                            HStack {
                                Spacer()
                                Text(vm.isLoginMode ? "Log In" : "Create Account")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 10)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                            }.background(Color.blue)
                            
                        }
                    }
                    .padding()
                    
                }
                .navigationTitle(vm.isLoginMode ? "Log In" : "Create Account")
                .background(Color(.init(white: 0, alpha: 0.05))
                                .ignoresSafeArea())
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $vm.shouldShowImagePicker, onDismiss: nil) {
            ImagePicker(image: $vm.image)
                .ignoresSafeArea()
        }
    }
    
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        
        LoginView(completeLogin : {})
        
        
    }
}

