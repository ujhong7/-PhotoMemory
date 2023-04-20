//
//  PlusMemory.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

class PlusMemoryView: UIView {
    
    var momoData: MemoData? {
        didSet {
            // configureUIwithData()
        }
    }
    
    
    // MARK: - Properties
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let memoTextField: UITextField  = {
        let tf = UITextField()
       
        return tf
    }()
    
//    private let memoDateLabel: UILabel = {
//        let date = UILabel()
//        date.text =
//        return date
//    }()
    
    
    lazy var stackView: UIStackView = {
        let stview = UIStackView(arrangedSubviews: [plusPhotoButton, memoTextField])
        stview.spacing = 10
        stview.axis = .vertical
        stview.distribution = .fill
        stview.alignment = .fill
        stview.translatesAutoresizingMaskIntoConstraints = false
        return stview
    }()
    
    
    
    
    // MARK: - Actions
    
    @objc func handlePhotoSelect() {
        print(#function)
    }
    
    
    // MARK: - LifeCycle
   
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setContraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setContraints() {
        self.addSubview(plusPhotoButton)
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            //plusPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusPhotoButton.widthAnchor.constraint(equalToConstant: 200),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    
    
    
    // MARK: - AutoLayout
    
    // 오토레이아웃 업데이트
   
    
    
}
