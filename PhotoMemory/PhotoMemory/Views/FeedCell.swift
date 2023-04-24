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
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "venom-7")
        
        
        return iv
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // backgroundColor = .red
        backgroundView = cellImageView
       
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUIwithData() {
        
    }
    
}
