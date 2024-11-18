//
//  LaunchUtils.swift
//  Pardus
//
//  Created by Igor Postoev on 17.11.24..
//

import Foundation

enum EnvironmentUtils {
    
    static var isInPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

