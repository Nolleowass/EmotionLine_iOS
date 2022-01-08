//
//  SplashViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit
import RxViewController
import Then
import SnapKit

final class SplashViewController:
    UIViewController,
    ReactorKit.View
{
    var disposeBag = DisposeBag()
    
    typealias Reactor = SplashViewReactor
    
    // MARK: - UI
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "")
    }
    
    
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
        
        setupLayout()
        setupView
    }
    
    private func setupLayout() {
        view.addSubview(logoImageView)
        
        logoImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
}

// MARK: - Bind Reactor

extension SplashViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        rx.viewDidLoad
            .map { Reactor.Action.checkLogin }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.viewType }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] viewType in
                guard let self = self else { return }
                
                switch viewType {
                case .feed:
                    let viewController = FeedViewController.makeViewController()
                    self.present(viewController, animated: true)
                case .login:
                    let viewController = LoginViewController.makeViewController()
                    self.present(viewController, animated: true)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
        
    }
}

extension SplashViewController {
    static func makeViewController() -> SplashViewController {
        let userDefaultService = UserDefaultsService()
        let reactor = Reactor(userDefaultsService: userDefaultService)
        return SplashViewController(reactor: reactor)
    }
}
