//
//  String.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 10/02/25.
//

import Foundation

extension String{
    
    /// Localized string for key.
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
}
