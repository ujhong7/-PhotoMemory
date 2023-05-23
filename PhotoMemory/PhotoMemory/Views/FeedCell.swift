//
//  FeedCell.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
import Kingfisher

class FeedCell: UICollectionViewCell {
    var memoData: MemoData?
    var imageView: UIImageView = UIImageView(frame: .zero)
    
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀의 모서리를 라운드 처리합니다.
        layer.cornerRadius = 3
        layer.masksToBounds = true
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureUI(data: Data) {
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        DispatchQueue.main.async {
            self.imageView.image = UIImage(data: data)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
