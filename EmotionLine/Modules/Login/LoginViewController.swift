//
//  LoginViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit
import UIKit

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
    
    let logoImage = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }
    
    let idLabel = UILabel().then {
        $0.text = "아이디"
        $0.textColor = UIColor.tintColor
    }
    let idTextField = UITextField().then {
        $0.borderStyle = .roundedRect
    }
    let passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.textColor = UIColor.tintColor
    }
    let passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.returnKeyType = .done
    }
    let findIdOrPasswordButton = UIButton().then {
        $0.setTitle("아이디/비밀번호 찾기", for: .normal)
    }
    let loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = UIColor.tintColor
    }
    let registerButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
    }
    
    let indicatorView = IndicatorView()
    
    // MARK: - Properties
    
    
    // MARK: - Initializing
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setupView()
        setupLayout()
    }
    
    private func setupView() {
        view.backgroundColor = .white
    }
    
    private func setupLayout() {
        view.addSubview(logoImage)
        view.addSubview(idLabel)
        view.addSubview(idTextField)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.addSubview(indicatorView)
        view.addSubview(findIdOrPasswordButton)
        
        logoImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(77.0)
        }
        
        idLabel.snp.makeConstraints { make in
            make.top.equalTo(logoImage.snp.bottom).offset(Metric.idLabelTop)
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
            make.right.equalTo(passwordTextField.snp.right)
        }

        loginButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Metric.leftRightPadding)
            make.bottom.equalTo(registerButton.snp.top).offset(5)
            make.height.equalTo(Metric.textFieldHeight)
        }

        registerButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
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
        
        reactor.state.map { $0.viewType }
            .distinctUntilChanged()
            .bind(onNext: { [weak self] viewType in
                guard let self = self else { return }
                switch viewType {
                case .feed:
                    let viewController = FeedViewController.makeViewController(service: reactor.service)
                    viewController.modalPresentationStyle = .fullScreen
                    self.present(viewController, animated: true)
                default:
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController {
    static func makeViewController(service: EmotionLineServiceProtocol) -> LoginViewController {
        let reactor = Reactor(service: service)
        return LoginViewController(reactor: reactor)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
