//
//  AppSafetyModel.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//

import Foundation

struct AppSafetyModel: Codable {
    let query_status : String?
    let urls : [Urls]?
}

struct Urls : Codable, Identifiable {
    let id : Int?
    let urlhaus_reference : String?
    let url : String?
    let url_status : String?
    let host : String?
    let date_added : String?
    let threat : String?
    let blacklists : Blacklists?
    let reporter : String?
    let larted : String?
    let tags : [String]?
}

struct Blacklists : Codable {
    let spamhaus_dbl : String?
    let surbl : String?
}
