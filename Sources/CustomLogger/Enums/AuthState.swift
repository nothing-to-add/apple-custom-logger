//
//  File name: AuthState.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

enum AuthState {
    case signedOut
    case signingIn
    case signedIn
    case signInFailed
    case signOut
    case tokenRefresh
    case tokenExpired
    
    var description: String {
        switch self {
        case .signedOut: return "User signed out"
        case .signingIn: return "User signing in"
        case .signedIn: return "User signed in successfully"
        case .signInFailed: return "Sign in failed"
        case .signOut: return "User signing out"
        case .tokenRefresh: return "Token refresh"
        case .tokenExpired: return "Token expired"
        }
    }
}
