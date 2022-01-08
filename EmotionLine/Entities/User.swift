//
//  User.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import Foundation

struct User: Codable {
    let accountId: Int
    let isPublic: Bool
    let userId: String
    let profileImageUrl: URL
    let username: String
    
    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case isPublic = "is_public"
        case userId = "user_id"
        case profileImageUrl = "profile_image_url"
        case username = "username"
    }
}
