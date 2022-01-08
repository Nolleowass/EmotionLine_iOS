//
//  SplashViewReactor.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit

enum ViewType {
    case none
    case login
    case feed
    case write
    case profile
}

final class SplashViewReactor: Reactor {
    enum Action {
        case checkLogin
    }
    
    enum Mutation {
        case setViewType(ViewType)
    }
    
    struct State {
        var viewType: ViewType = .none
    }
    
    let initialState: State
    let userDefaultsService: UserDefaultsServiceProtocol
    
    init(
        userDefaultsService: UserDefaultsServiceProtocol
    ) {
        initialState = State()
        self.userDefaultsService = userDefaultsService
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkLogin:
            let isLogin = userDefaultsService.checkIsLogin()
            let viewType: ViewType = isLogin ? .feed : .login
            return .just(.setViewType(viewType))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setViewType(let viewType):
            state.viewType = viewType
        }
        
        return state
    }
}
