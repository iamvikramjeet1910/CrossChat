//
//  SettingsOptionsViewModel.swift
//  CrossChat
//
//  Created by Vikram Kumar on 18/02/25.
//

import Foundation

enum SettingsOptionsViewModel: Int, CaseIterable, Identifiable {
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
    
    var id: Int { return self.rawValue }
}
