//
//  FeedViewReactor.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit

final class FeedViewReactor: Reactor {
    enum Action {
        <#case#>
    }
    
    enum Mutation {
        <#case#>
    }
    
    struct State {
        <#properties#>
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case <#pattern#>:
            <#code#>
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case <#pattern#>:
            <#code#>
        }
        
        return state
    }
}

extension FeedViewReactor {
    <#code#>
}
