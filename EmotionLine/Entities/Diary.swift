//
//  Diary.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import Foundation

struct Diary: Codable {
    let diaryId: Int
    let accountId: Int
    let content: String
    let emotionPoint: Int
    let createAt: Date
    
    enum CodingKeys: String, CodingKey {
        case diaryId = "diary_id"
        case accountId = "account_id"
        case content
        case emotionPoint = "emotion_point"
        case createAt = "create_at"
    }
}
