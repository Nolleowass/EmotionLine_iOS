//
//  DiaryTableViewCell.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import RxSwift

class DiaryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var emojiImageView: UIImageView!
    
    @IBOutlet weak var emojiDescriptionLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var textViewLabel: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius = 10;
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = UIColor(named: "TintColor2")
        
        bind()
    }
    
    var disposeBag = DisposeBag()
    
    private func bind() {
        editButton.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(onNext: {
                
            })
            .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(diary: Diary) {
        textViewLabel.text = diary.content
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: diary.createAt) ?? Date()
        formatter.dateFormat = "MM월 dd일"
        dateLabel.text = formatter.string(from: date)
        
        descriptionLabel.text = "좋음 지수 \(diary.emotionPoint)점"
        
        if diary.emotionPoint < 20 {
            emojiDescriptionLabel.text = "Very Bad"
            emojiImageView.image = UIImage(named: "verybad")
        } else if diary.emotionPoint < 40 {
            emojiDescriptionLabel.text = "Bad"
            emojiImageView.image = UIImage(named: "bad")
        } else if diary.emotionPoint < 60 {
            emojiDescriptionLabel.text = "SoSo"
            emojiImageView.image = UIImage(named: "soso")
        } else if diary.emotionPoint < 80 {
            emojiDescriptionLabel.text = "Good"
            emojiImageView.image = UIImage(named: "good")
        } else if diary.emotionPoint < 100 {
            emojiDescriptionLabel.text = "Very Good"
            emojiImageView.image = UIImage(named: "verygood")
        }
    }
}
