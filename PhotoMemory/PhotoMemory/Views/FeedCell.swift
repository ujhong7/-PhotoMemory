//
//  FeedCell.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
// import Kingfisher

class FeedCell: UICollectionViewCell {
    var memoData: MemoData?
    
    var memoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 3
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
   
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(memoImage)
        NSLayoutConstraint.activate([
            memoImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            memoImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            memoImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            memoImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configureMemoImage(_ image: UIImage) {
        memoImage.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
