//
//  WriteViewReactor.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import ReactorKit
import RxCocoa
import RxSwift

final class WriteViewReactor: Reactor {
    
    enum Action {
        case complete(String)
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    let initialState: State = State()
    let service = EmotionLineService()
    
    init() {
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .complete(let content):
            return service.createDiary(content)
                .asObservable()
                .flatMap { _ -> Observable<Mutation> in
                    return .empty()
                }
        }
    }
}
