//
//  SignupView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 17/02/25.
//

import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        
        VStack{
            //Spacer()
            Image("messenger-app-icon")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
            VStack{
                TextField("Enter your email", text: $email)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                TextField("Enter your full name", text: $fullname)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
                
                SecureField("Enter your password", text: $password)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal, 24)
            }
        }
        
        Button{
            print("Handle Signup")
        } label: {
            Text("Sign Up")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 360, height: 44)
                .background(Color(.systemBlue))
                .cornerRadius(10)
        }
        .padding(.vertical)
        
        Divider()
        
        
        Button{
            dismiss()
        } label: {
            HStack{
                Text("Already have an account?")
                Text("Sign In")
                    .fontWeight(.semibold)
            }
            .font(.footnote)
        }
        .padding(.vertical)
          
    }
}

#Preview {
    SignupView()
}
