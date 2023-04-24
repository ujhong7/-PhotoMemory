//
//  FeedCell.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

class FeedCell: UICollectionViewCell {
    
    var memoData: MemoData?  {
        didSet {
            configureUIwithData()
        }
    }
    
    // MARK: - properties
    private let cellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "venom-7")
        return imageView
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // backgroundColor = .red
        //backgroundView = cellImageView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIwithData() {
//        cellImageView.image = UIImage(data: (memoData?.photo)!)!
        
    }
    
}
