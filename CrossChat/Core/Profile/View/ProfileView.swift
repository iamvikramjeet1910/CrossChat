//
//  ProfileView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/02/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            // header
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(Color(.systemGray4))
                
                Text("Vikram Kumar")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            // List
            List {
                Section {
                    ForEach(SettingsOptionsViewModel.allCases) { option in
                        HStack {
                            Image(systemName: "bell.circle.fill")
                                .resizable()
                                .frame(width:24, height: 24)
                                .foregroundColor(Color(.systemPurple))
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                Section {
                    Button("Log Out") {
                        
                    }
                    Button("Delete Account") {
                        
                    }
                }
                .foregroundColor(.red)
            }
            
        }
    }
}

#Preview {
    ProfileView()
}
