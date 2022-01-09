//
//  ChartSection.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import RxDataSources

enum CategorySection {
    case chart([Item])
    case diary([Item])
    case visitor([Item])
}

extension CategorySection: SectionModelType {
    typealias Item = CategorySectionItem
    
    var items: [Item] {
        switch self {
        case .chart(let items):
            return items
        case .diary(let items):
            return items
        case .visitor(let items):
            return items
        }
    }
    
    init(original: Self, items: [Item]) {
        switch original {
        case .chart:
            self = .chart(items)
        case .diary:
            self = .diary(items)
        case .visitor:
            self = .visitor(items)
        }
    }
}

enum CategorySectionItem {
    case graph([Diary])
    case calendar([Diary])
    case selectedDiary(Diary)
    case visitor([User])
}
