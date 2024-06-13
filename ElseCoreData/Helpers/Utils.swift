//
//  Utils.swift
//  ElseCoreData
//
//  Created by Саша Восколович on 13.06.2024.
//

import SwiftUI

extension EnvironmentValues {
    static var isPreview: Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}

extension Thread {
     var isRunningXCTest: Bool {
        for key in self.threadDictionary.allKeys {
            guard let keyAsString = key as? String else { continue }
            
            if keyAsString.split(separator: ".").contains("xctest") {
                return true
            }
        }
        return false
    }
}
