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
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.image = #imageLiteral(resourceName: "venom-7")
        iv.translatesAutoresizingMaskIntoConstraints = false // ⭐️ 자동으로 위치 정렬 금지
        return iv
    }()
    
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        
        addSubview(imageView)
        //제약조건 설정하기
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - <#내용입력#>
    
    func configureUIwithData() {
        
    }
    
}
