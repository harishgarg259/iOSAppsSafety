//
//  FontTheme.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//

import SwiftUI

let appFontName = "Rubik"
/// Text styles used throughout the app.
protocol FontTheme {
    
    // MARK: - Generic Text Styles
    /// Large Title text style.
    var largeTitleTextStyle: Font { get }
    
}

enum Fonts: String {
    case Black = "-Black"
    case Bold = "-Bold"
    case Light = "-Light"
    case Regular = "-Regular"
    case Medium = "-Medium"
    func font(_ size: CGFloat) -> Font {
        return Font.custom("\(appFontName)\(self.rawValue)", size: size)
    }
}
