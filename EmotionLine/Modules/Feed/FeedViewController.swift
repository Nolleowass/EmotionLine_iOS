//
//  FeedViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit

final class FeedViewController:
    UIViewController,
    View
{
    typealias Reactor = FeedViewReactor
    
    // MARK: - UI
    
    
    // MARK: - Properties
    
    
    // MARK: - Initializing
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

// MARK: - Bind Reactor

extension FeedViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        <#code#>
    }
    
    private func bindState(reactor: Reactor) {
        <#code#>
    }
}

extension FeedViewController {
    static func makeViewController() -> FeedViewController {
        let reactor = Reactor()
        return FeedViewController(reactor: reactor)
    }
}
