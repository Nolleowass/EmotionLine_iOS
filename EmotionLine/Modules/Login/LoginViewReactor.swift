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
        case setViewType(ViewType)
    }
    
    struct State {
        var isLoading: Bool = false
        var viewType: ViewType = .none
    }
    
    let initialState: State
    
    let service: EmotionLineServiceProtocol
    
    init(
        service: EmotionLineServiceProtocol
    ) {
        initialState = State()
        self.service = service
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login(let id, let password):
            let loginProcess = service.login(id, password)
                .flatMap { _ -> Observable<Mutation> in
                    return .just(.setViewType(.feed))
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
        case .setViewType(let viewType):
            state.viewType = viewType
        }
        
        return state
    }
}
