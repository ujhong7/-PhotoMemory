//
//  CalendarCollectionViewCell.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/05/02.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "CalenderCollectionViewCell"
    private lazy var dayLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    func update(day: String) {
           self.dayLabel.text = day
        
       }
    
    private func configure() {
        // 셀 테두리
        layer.cornerRadius = 3
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        self.addSubview(self.dayLabel)
        // dayLabel.text = "0"
        dayLabel.font = .boldSystemFont(ofSize: 12)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            dayLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    private func aaa() {
       // calender
    }
    
    
}
