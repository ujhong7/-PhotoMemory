//
//  NoDataViewController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/05/03.
//

import UIKit

class NoDataViewController: UIViewController {
    
    private let memoManager = CoreDataManager.shared
    
    var memoData: MemoData?
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        if let date = memoData?.date {
            label.text = formatter.string(from: date)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var text: UITextView = {
        let textView = UITextView()
        textView.text = "dddkdkdkdkdk"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        setContraints()
    }
    
    // ?월 ?일에 기록된 메모가 없습니다!
    func setContraints() {
//        view.addSubview(dateLabel)
//        NSLayoutConstraint.activate([
//            dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            dateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
        
        view.addSubview(text)
        NSLayoutConstraint.activate([
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
    }
    
    
}
