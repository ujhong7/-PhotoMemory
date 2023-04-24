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
    
    // (델리게이트 대신에) 실행하고 싶은 클로저 저장
    // 뷰컨트롤러에 있는 클로저 저장할 예정 (셀(자신)을 전달)
//    var updateButtonPressed: (FeedCell) -> Void = { (sender) in }
    
    
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
