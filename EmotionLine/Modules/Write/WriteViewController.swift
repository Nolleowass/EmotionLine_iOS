//
//  WriteViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import UIKit

import ReactorKit
import RxSwift
import RxCocoa

final class WriteViewController: UIViewController, StoryboardView {
    
    var disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleItem.title = "1월 7일"
        titleItem.titleView?.tintColor = .white
    }

    func bind(reactor: WriteViewReactor) {
        cancelButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        completeButton.rx.tap
            .bind(onNext: { [weak self] in
                reactor.action.onNext(.complete(self?.textView.text ?? ""))
            })
            .disposed(by: disposeBag)
    }
    
}
