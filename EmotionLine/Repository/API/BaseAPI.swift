//
//  BaseAPI.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import Moya

protocol BaseAPI: TargetType {}

extension BaseAPI {
    var baseURL: URL { URL(string: "https://nolleowass-api.jasonchoi.dev")! }
    
    var method: Method { .get }
    
    var sampleData: Data { Data() }
    
    var task: Task { .requestPlain }
    
    var headers: [String: String]? { nil }
}
