//
//  Enum.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 10/02/25.
//

import Foundation

public enum SortingType: String{
    case Date
}

enum FetchState: Comparable {
    case idle
    case isLoading
    case loadedAllApps
    case error(String)
}
