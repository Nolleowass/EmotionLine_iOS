//
//  Network.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import Moya

import RxSwift
import Moya

class Network<API: TargetType>: MoyaProvider<API> {
    init(plugins: [PluginType] = []) {
        let session = MoyaProvider<API>.defaultAlamofireSession()
        session.sessionConfiguration.timeoutIntervalForRequest = 10
        
        super.init(session: session, plugins: plugins)
    }
    
    func request(_ api: API) -> Single<Response> {
        return self.rx.request(api)
            .filterSuccessfulStatusCodes()
    }
}

extension Network {
    func requestWithoutMapping(_ target: API) -> Single<Void> {
        return request(target)
            .map { _ in }
    }
    
    func requestObject<T: Codable>(_ target: API, type: T.Type) -> Single<T> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map(T.self, using: decoder)
    }
    
    func requestArray<T: Codable>(_ target: API, type: T.Type) -> Single<[T]> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return request(target)
            .map([T].self, using: decoder)
    }
}
