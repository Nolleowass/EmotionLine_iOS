//
//  FeedViewController.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/08.
//

import ReactorKit
import RxDataSources
import ReusableKit
import UIKit

final class FeedViewController:
    UIViewController,
    ReactorKit.View
{
    var disposeBag = DisposeBag()
    
    typealias Reactor = FeedViewReactor
    
    // MARK: - UI
    private struct Reusable {
        static let graphCell = ReusableCell<GraphTableViewCell>()
        static let calendarCell = ReusableCell<CalendarTableViewCell>()
        static let diaryCell = ReusableCell<DiaryTableViewCell>()
        static let visitorCell = ReusableCell<VisitorTableViewCell>()
    }
    
    struct Metric {
        static let graphCellHeight: CGFloat = 270.0
        static let calendarCellHeight: CGFloat = 200.0
        static let diaryCellHeight: CGFloat = 250.0
        static let historyCellHeight: CGFloat = 250.0
        static let visitorCellHeight: CGFloat = 100.0
    }
    
    lazy var tableView = UITableView().then {
        $0.register(Reusable.graphCell)
        $0.register(Reusable.calendarCell)
        $0.register(UINib(nibName: "DiaryTableViewCell", bundle: nil), forCellReuseIdentifier: "DiaryTableViewCell")
        $0.register(UINib(nibName: "VisitorTableViewCell", bundle: nil), forCellReuseIdentifier: "VisitorTableViewCell")
        $0.delegate = self
        $0.separatorStyle = .none
    }
    
    let logoButton = UIButton().then {
        $0.setImage(UIImage(named: "SmallLogo"), for: .normal)
    }
    
    lazy var customNavigationBar = UINavigationBar().then {
        $0.topItem?.title = ""
        $0.backgroundColor = UIColor(named: "TintColor")
    }
    
    lazy var customNavigationItem = UINavigationItem().then {
        $0.leftBarButtonItems = [
            UIBarButtonItem(customView: logoButton),
        ]
    }

    
    let writeButton = UIButton().then {
        $0.setImage(UIImage(named: "WriteButton"), for: .normal)
    }
    
    // MARK: - Properties
    private let dataSource: RxTableViewSectionedReloadDataSource<CategorySection>
    
    
    // MARK: - Initializing
    
    init(reactor: Reactor) {
        defer { self.reactor = reactor }
        dataSource = Self.dataSourceFactory()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(customNavigationBar)
        view.addSubview(tableView)
        view.addSubview(writeButton)
        setupView()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(20)
        }
        
        writeButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-14)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private static func dataSourceFactory() -> RxTableViewSectionedReloadDataSource<CategorySection> {
        return .init(
            configureCell: { dataSource, tableView, indexPath, sectionItem in
                switch sectionItem {
                case .graph(let diaryList):
                    let cell = tableView.dequeue(Reusable.graphCell, for: indexPath)
                    cell.setup(diaryList: diaryList)
                    return cell
                    
                case .calendar(let diaryList):
                    let cell = tableView.dequeue(Reusable.calendarCell, for: indexPath)
//                    cell.setup(diaryList: diaryList)
                    return cell
                    
                case .selectedDiary(let diary):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "DiaryTableViewCell") as? DiaryTableViewCell
                    cell?.setup(diary: diary)
                    return cell ?? UITableViewCell()
                    
                case .visitor(let userList):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "VisitorTableViewCell") as? VisitorTableViewCell
                    cell?.setup(userList: userList)
                    return cell ?? UITableViewCell()
                }
            }
        )
    }
}

// MARK: - Bind Reactor

extension FeedViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        rx.viewWillAppear
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(onNext: { [weak self] in
                let vc = UIStoryboard(name: "Write", bundle: nil).instantiateViewController(withIdentifier: "Write") as? WriteViewController
                self?.present(vc ?? UIViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.sections }
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionItem = self.dataSource[indexPath]
        
        switch sectionItem {
        case .graph:
            return Metric.graphCellHeight
            
        case .calendar:
            return Metric.calendarCellHeight
            
        case .selectedDiary:
            return Metric.diaryCellHeight
            
        case .visitor:
            return Metric.visitorCellHeight
        }
    }
}

extension FeedViewController {
    static func makeViewController(service: EmotionLineServiceProtocol) -> FeedViewController {
        let reactor = Reactor(service: service)
        return FeedViewController(reactor: reactor)
    }
}
