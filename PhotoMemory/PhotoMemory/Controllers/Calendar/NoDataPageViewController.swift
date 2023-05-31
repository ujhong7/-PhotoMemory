//
//  NoDataPageViewController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/05/16.
//

import UIKit

class NoDataPageViewController: UIViewController {
    private let memoManager = CoreDataManager.shared
    var currentSelectedDate: Date?
    
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 메모가 없습니다"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setPlusButton() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func plusButtonTapped() {
        let controller = PlusMemoryController(type: .createType, currentSelectedDate: currentSelectedDate)
        navigationController?.pushViewController(controller, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        print("DEBUG: plusButtonTapped")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setPlusButton()
        view.addSubview(noDataLabel)
        setContraints()
    }
    
    func setContraints() {
        // UILabel을 수평 및 수직 중앙에 위치시키는 제약 조건 추가
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
