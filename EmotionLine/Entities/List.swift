//
//  List.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import Foundation

struct List<T: Codable>: Codable {
    let list: [T]
    
    enum CodingKeys: String, CodingKey {
        case list = "diary_list"
    }
}
