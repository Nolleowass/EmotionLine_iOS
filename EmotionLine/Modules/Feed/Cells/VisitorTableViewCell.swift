//
//  VisitorTableViewCell.swift
//  EmotionLine
//
//  Created by 강민석 on 2022/01/09.
//

import UIKit

class VisitorTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
//        collectionView.dataSource = self
//        tableView.register(UINib(nibName: "", bundle: nil), forCellReuseIdentifier: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(userList: [User]) {
        label.text = "\(userList.first?.username)외 \(userList.count)몇이 방문했어요."
        collectionView.reloadData()
    }
    
}

//extension VisitorTableViewCell: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//}
