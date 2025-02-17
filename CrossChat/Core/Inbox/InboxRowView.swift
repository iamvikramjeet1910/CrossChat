//
//  InboxRowView.swift
//  CrossChat
//
//  Created by Vikram Kumar on 17/02/25.
//

import SwiftUI

struct InboxRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 64, height: 64)
                .foregroundColor(Color(.systemGray4))
            VStack(alignment: .leading, spacing: 4) {
                Text("Aditya")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Some text message for now jhdafgkuyfb ygjnbiuy jdghu jhju")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            HStack {
                Text("Yesterday")
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
        //.padding(.horizontal)
        .frame(height: 72)
         
    }
}

#Preview {
    InboxRowView()
}
