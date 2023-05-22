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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 셀의 서브 레이어를 순회하며 circleLayer 인스턴스를 찾아 삭제합니다.
        layer.sublayers?.forEach {
            if let circleLayer = $0 as? CAShapeLayer {
                circleLayer.removeFromSuperlayer()
            }
        }
        self.backgroundColor = .white
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
    
    func existData() {
        backgroundColor = .white
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let circlePath = UIBezierPath(arcCenter: centerPoint, radius: 2.5, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = UIColor.gray.cgColor
        layer.addSublayer(circleLayer)
    }
}
