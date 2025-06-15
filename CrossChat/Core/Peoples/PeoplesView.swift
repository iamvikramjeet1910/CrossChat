//
//  PeoplesView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 14/06/25.
//

// PeoplesView.swift
import SwiftUI

struct PeoplesView: View {
    @StateObject var viewModel = PeoplesViewModel()
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("All Users")
                .font(.title .bold())
                .padding(.horizontal)
            
            ScrollView {
                if let error = viewModel.errorMessage {
                    Text(error).foregroundColor(.red)
                } else if viewModel.isLoading {
                    ProgressView()
                } else {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(viewModel.users) { user in
                            PeopleView(user: user) {
                                // Handle add button tap, e.g.:
                                print("Add tapped for \(user.fullname)")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
