//
//  File name: AppLifecycleEvent.swift
//  Project name: apple-custom-logger
//  Workspace name: apple-custom-logger
//
//  Created by: nothing-to-add on 13/09/2025
//  Using Swift 6.0
//  Copyright (c) 2023 nothing-to-add
//

import Foundation

public enum AppLifecycleEvent {
    case launching
    case launched
    case backgrounding
    case foregrounding
    case terminating
    case memoryWarning
    
    public var description: String {
        switch self {
        case .launching: return "App is launching"
        case .launched: return "App launch completed"
        case .backgrounding: return "App entering background"
        case .foregrounding: return "App entering foreground"
        case .terminating: return "App terminating"
        case .memoryWarning: return "Memory warning received"
        }
    }
}
