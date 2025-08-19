//
//  Untitled.swift
//  ColorConverter
//
//  Created by David Sherlock on 03/08/2025.
//

import Foundation

// MARK: - String Extensions

internal extension String {
    
    /// Normalized color string (trimmed)
    var normalizedColor: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Check if string matches a regex pattern
    func matches(_ pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression) != nil
    }
    
}
