//
//  GraphTableViewCell.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import UIKit
import Charts
import RxSwift

class GraphTableViewCell: UITableViewCell {
    
    // MARK: - UI
    var disposeBag = DisposeBag()
    
    struct Metric {
        static let leftRightPadding: CGFloat = 20.0
        static let topPadding: CGFloat = 25.0
        static let buttonSize: CGFloat = 34.0
        static let graphHeight: CGFloat = 140.0
        static let arrowButtonSize: CGFloat = 14.0
        static let buttonPadding: CGFloat = 8.0
        static let arrowButtonTop: CGFloat = 15.0
    }
    
    let descriptionLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 16)
        $0.text = "지원님, 31일 동안의 이야기가 모여 그려진 글자리를 따라가보세요."
        $0.numberOfLines = 2
    }
    
    let changeGraphToCalendarButton = UIButton().then {
        $0.setImage(UIImage(named: "CalendarButton"), for: .normal)
    }
    
    let prevButton = UIButton().then {
        $0.setImage(UIImage(named: "PrevArrow"), for: .normal)
    }
    
    let monthLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .black
    }
    
    let nextButton = UIButton().then {
        $0.setImage(UIImage(named: "NextArrow"), for: .normal)
    }
    
    let searchButton = UIButton().then {
        $0.titleLabel?.font = .systemFont(ofSize: 14)
        $0.setTitle("검색", for: .normal)
    }
    
    let graphView = LineChartView()

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(changeGraphToCalendarButton)
        contentView.addSubview(prevButton)
        contentView.addSubview(monthLabel)
        contentView.addSubview(nextButton)
        contentView.addSubview(graphView)
        
        setupLayout()
        
        prevButton.rx.tap
            .bind(onNext: {
                NotificationCenter.default.post(name: NSNotification.Name("prev"), object: nil, userInfo: ["isPrev": true])
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(onNext: {
                NotificationCenter.default.post(name: NSNotification.Name("prev"), object: nil, userInfo: ["isPrev": false])
            })
            .disposed(by: disposeBag)
    }
    
    private func setupLayout() {
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.topPadding)
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.right.equalTo(changeGraphToCalendarButton.snp.left).offset(-Metric.leftRightPadding)
        }
        
        changeGraphToCalendarButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.top)
            make.right.equalToSuperview()
            make.size.equalTo(Metric.buttonSize)
        }
        
        prevButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.arrowButtonTop)
            make.left.equalToSuperview().offset(Metric.leftRightPadding)
            make.size.equalTo(Metric.arrowButtonSize)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.arrowButtonTop)
            make.left.equalTo(prevButton.snp.right).offset(Metric.buttonPadding)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Metric.arrowButtonTop)
            make.left.equalTo(monthLabel.snp.right).offset(Metric.buttonPadding)
            make.size.equalTo(Metric.arrowButtonSize)
        }
        
        graphView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.graphHeight)
            make.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func setupGraph(points: [Double], days: [Double]) {
        graphView.xAxis.enabled = false
        graphView.rightAxis.enabled = false
        graphView.leftAxis.enabled = false
        graphView.legend.enabled = false
        
        var dataEntries = [ChartDataEntry]()
        for i in 0..<points.count {
            let dataEntry = ChartDataEntry(x: days[i], y: points[i])
            dataEntries.append(dataEntry)
        }
        
        let line = LineChartDataSet(entries: dataEntries, label: nil)
        line.colors = [NSUIColor.tintColor]
    
        let data = LineChartData(dataSet: line)
        graphView.data = data
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    func setup(diaryList: [Diary]) {
        let emotionPoints = diaryList.map { Double($0.emotionPoint) }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dates = diaryList.map {
            return formatter.date(from: $0.createAt) ?? Date()
        }
        
        formatter.dateFormat = "dd"
        let emotionDays = dates.map {
            return Double(formatter.string(from: $0)) ?? 0.0
        }
        
        formatter.dateFormat = "MM월"
        monthLabel.text = formatter.string(from: dates.first ?? Date())
        
        setupGraph(points: emotionPoints, days: emotionDays)
    }

}
