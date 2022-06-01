//
//  ImageModalCollection.swift
//  white and fluffy test
//
//  Created by Георгий Маркарян on 31.05.2022.
//

import UIKit
struct ImagesResults: Decodable, Encodable, Equatable{
    static func == (lhs: ImagesResults, rhs: ImagesResults) -> Bool {
        lhs.urls == rhs.urls
    }
    
    let width: Int
    let height: Int
    let downloads: Int
    let created_at: String
    let location: Location?
    let urls: [URLKing.RawValue:String]
    let user: User?
    
    
    enum URLKing: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
    
}
struct Location: Encodable, Decodable{
    let name : String?
}
struct User: Encodable, Decodable{
    let username: String?
    let name: String?
}

