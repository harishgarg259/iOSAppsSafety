//
//  RequestUrl.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 10/02/25.
//

import Foundation

enum RequestUrl :String{
    
    //App Base URL
    static var BaseURL = "https://urlhaus-api.abuse.ch/v1"
    //Complete API url
    var url : String{ return RequestUrl.BaseURL + self.rawValue }
    
    
    //Apps Screen Apis
    case appsListing = "/urls/recent"
    
}
