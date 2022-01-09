//
//  LoginResponse.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import Foundation

struct LoginResponse: Codable {
    let userId: String
    let token: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case token
    }
}
