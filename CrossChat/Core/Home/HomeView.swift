//
//  HomeView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 14/06/25.
//


import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            InboxView().tabItem { Label("Inbox", systemImage: "bubble.left.and.bubble.right.fill") }
            PeoplesView()
                .tabItem {
                    Image(systemName: "person.3.fill") // People/community icon
                    Text("Add Friends")
                }
            ProfileView(user: viewModel.currentUser ?? User.MOCK_USER).tabItem { Label("Profile", systemImage: "person.crop.circle.fill") }
        }
    }
}

