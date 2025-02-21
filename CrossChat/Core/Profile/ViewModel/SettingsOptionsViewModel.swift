//
//  SettingsOptionsViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/02/25.
//

import Foundation
import SwiftUICore

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
    //var id: ObjectIdentifier
    
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notifications
    
    var title: String {
        switch self {
            
        case .darkMode:
            return "Dark mode"
        case .activeStatus:
            return "Active status"
        case .accessibility:
            return "Accessibility"
        case .privacy:
            return "Privacy and Safety"
        case .notifications:
            return "Notifications"
        }
    }
        
        var imageName: String {
            switch self {
            case .darkMode: return "moon.circle.fill"
            case .activeStatus: return "message.badge.circle.fill"
            case .accessibility: return "person.circle.fill"
            case .privacy: return "lock.circle.fill"
            case .notifications: return "bell.circle.fill"
            }
        }
        
        var imageBackgroundColor: Color {
            switch self {
            case .darkMode: return .black
            case .activeStatus: return Color(.systemGreen)
            case .accessibility: return .black
            case .privacy: return Color(.systemBlue)
            case .notifications: return Color(.systemPurple)
            }
        }

        
        var id: Int { return self.rawValue }
}
