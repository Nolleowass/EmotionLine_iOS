//
//  LoginViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit

final class LoginViewController:
    UIViewController,
    ReactorKit.View
{
    typealias Reactor = LoginViewReactor
    
    var disposeBag = DisposeBag()
    
    // MARK: - UI
    fileprivate struct Metric {
        static let leftRightPadding: CGFloat = 20.0
        static let textFieldHeight: CGFloat = 48.0
        static let idLabelPadding: CGFloat = 5.0
        static let idLabelTop: CGFloat = 40.0
    }
    
    let idLabel = UILabel().then {
        $0.text = "아이디"
    }
    let idTextField = UITextField()
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
    }
    let passwordTextField = UITextField()
    let findIdOrPasswordButton = UIButton().then {
        $0.setTitle("아이디/비밀번호 찾기", for: .normal)
    }
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
    }
    let registerButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
    }
    
    let indicatorView = IndicatorView()
    
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
        
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(indicatorView)
    }
    
    private func setupLayout() {
        idLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.idLabelTop)
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
        }
        
        idTextField.snp.makeConstraints { make in
            make.top.equalTo(idLabel.snp.bottom).offset(Metric.idLabelPadding)
            make.left.right.equalToSuperview().inset(Metric.leftRightPadding)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        passwordLabel.snp.makeConstraints { make in
            make.top.equalTo(idTextField.snp.bottom).offset(25.0)
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(Metric.idLabelPadding)
            make.left.right.equalToSuperview().inset(Metric.leftRightPadding)
            make.height.equalTo(Metric.textFieldHeight)
        }
        
        findIdOrPasswordButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(Metric.idLabelPadding)
            make.right.equalToSuperview().offset(-Metric.leftRightPadding)
        }
        
        registerButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Metric.leftRightPadding)
            make.bottom.equalTo(registerButton.snp.top)
            make.height.equalTo(Metric.textFieldHeight)
        }
    }
}

// MARK: - Bind Reactor

extension LoginViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        loginButton.rx.tap
            .map { [weak self] in
                let id = self?.idTextField.text ?? ""
                let password = self?.passwordTextField.text ?? ""
                return Reactor.Action.login(id: id, password: password)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.isLoading }
            .distinctUntilChanged()
            .bind(to: indicatorView.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    static func makeViewController() -> LoginViewController {
        let emotionLineService = EmotionLineService()
        let reactor = Reactor(emotionLineService: emotionLineService)
        return LoginViewController(reactor: reactor)
    }
}
