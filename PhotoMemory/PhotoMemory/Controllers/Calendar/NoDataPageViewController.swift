//
//  NoDataPageViewController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/05/16.
//

import UIKit

class NoDataPageViewController: UIViewController {
    
    private let memoManager = CoreDataManager.shared

    var memoDataArray: [MemoData]?
    var memoData: MemoData?
    
    var currentSelectedDate: Date?
    
//    private lazy var dateLabel: UILabel = {
//        let label = UILabel()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy년 MM월 dd일"
//        if let date = memoData?.date {
//            label.text = formatter.string(from: date)
//        }
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
     
        label.text = "저장된 메모가 없습니다"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupNaviBar() {
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func plusButtonTapped() {
        let controller = PlusMemoryController(type: .createType, currentSelectedDate: currentSelectedDate)
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        setupNaviBar()
    
        view.addSubview(noDataLabel)
        
        // UILabel을 수평 및 수직 중앙에 위치시키는 제약 조건 추가
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
