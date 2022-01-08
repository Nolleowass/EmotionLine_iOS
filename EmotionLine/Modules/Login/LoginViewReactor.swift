//
//  LoginViewReactor.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit

final class LoginViewReactor: Reactor {
    enum Action {
        case login(id: String, password: String)
    }
    
    enum Mutation {
        case setLoading(isLoading: Bool)
    }
    
    struct State {
        var isLoading: Bool = false
    }
    
    let initialState: State
    
    let emotionLineService: EmotionLineServiceProtocol
    
    init(
        emotionLineService: EmotionLineServiceProtocol
    ) {
        initialState = State()
        self.emotionLineService = emotionLineService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login(let id, let password):
            let loginProcess = emotionLineService.login(id, password)
                .flatMap { _ -> Observable<Mutation> in
                    return Observable.empty()
                }
            
            return .concat([
                .just(.setLoading(isLoading: true)),
                loginProcess,
                .just(.setLoading(isLoading: false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        
        return state
    }
}
