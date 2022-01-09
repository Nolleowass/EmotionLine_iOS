//
//  IndicatorView.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import UIKit
import RxSwift
import RxCocoa

final class IndicatorView: UIView {
    
    private let indicatorView = UIActivityIndicatorView().then {
        $0.color = .black
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints { make in
            make.size.equalTo(30)
            make.center.equalToSuperview()
        }
    }
    
    func startAnimating() {
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        indicatorView.stopAnimating()
    }
}

extension Reactive where Base: IndicatorView {
    var isAnimating: Binder<Bool> {
        return Binder(base) { indicatorView, isAnimating in
            if isAnimating {
                indicatorView.startAnimating()
            } else {
                indicatorView.stopAnimating()
            }
        }
    }
}
