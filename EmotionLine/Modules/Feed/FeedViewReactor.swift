//
//  FeedViewReactor.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit
import Foundation

final class FeedViewReactor: Reactor {
    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setIsLoading(Bool)
        case setChartSectionItems([Diary])
        case setDiarySectionItems(Diary)
        case setVisitorSectionItems([User])
        case setMonth(Int)
    }
    
    typealias Section = CategorySection
    typealias SectionItem = CategorySectionItem
    
    struct State {
        var isLoading: Bool = false
        var currentUserId: String = ""
        var year: Int = 2022
        var month: Int = 1
        
        var isGraph: Bool = true
        
        var selectedDiary: Diary = Diary(diaryId: 0, accountId: 0, content: "", emotionPoint: 0, createAt: "")
        
        var chartSectionItems: [SectionItem] = []
        var diarySectionItems: [SectionItem] = []
        var visitorSectionItems: [SectionItem] = []
        var sections: [Section] {
            let sections: [Section] = [
                .chart(chartSectionItems),
                .diary(diarySectionItems),
                .visitor(visitorSectionItems)
            ]
            return sections
        }
    }
    
    let initialState: State
    let service: EmotionLineServiceProtocol
    
    init(
        service: EmotionLineServiceProtocol
    ) {
        initialState = State(currentUserId: service.getCurrentUserId())
        self.service = service
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let noti = NotificationCenter.default.rx.notification(Notification.Name("prev"), object: nil)
            .flatMap { [weak self] notification -> Observable<Mutation> in
                guard let isPrev = notification.userInfo?["isPrev"] as? Bool,
                let self = self else {
                    return Observable.empty()
                }
                
                let month = isPrev ? self.currentState.month - 1 : self.currentState.month + 1
                return .just(.setMonth(month))
            }

        return .merge([mutation, noti])
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return .concat([
                .just(.setIsLoading(true)),
                getDiaryList(),
                getAnotherProfileList(),
                .just(.setIsLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case .setIsLoading(let isLoading):
            state.isLoading = isLoading
            
        case .setChartSectionItems(let diaryList):
            if currentState.isGraph {
                state.chartSectionItems.append(
                    .graph(diaryList)
                )
            } else {
                state.chartSectionItems.append(
                    .calendar(diaryList)
                )
            }
            
        case .setDiarySectionItems(let selectedDiary):
            state.diarySectionItems.append(
                .selectedDiary(selectedDiary)
            )
            
        case .setVisitorSectionItems(let userList):
            state.visitorSectionItems.append(
                .visitor(userList)
            )
            
        case .setMonth(let month):
            state.month = month
        }
        
        return state
    }
}

extension FeedViewReactor {
    private func getDiaryList() -> Observable<Mutation> {
        return service.getDiaryList(
            currentState.currentUserId,
            currentState.year,
            currentState.month
        ).asObservable()
            .flatMap { diaryList -> Observable<Mutation> in
                return .concat([
                    .just(.setChartSectionItems(diaryList)),
                    .just(.setDiarySectionItems(diaryList.first!))
                ])
            }
    }
    
    private func getAnotherProfileList() -> Observable<Mutation> {
        return service.anotherProfileList()
            .asObservable()
            .flatMap { userList -> Observable<Mutation> in
                return .concat([
                    .just(.setVisitorSectionItems(userList))
                ])
            }
    }
}
