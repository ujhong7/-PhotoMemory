//
//  DetailViewController.swift
//  PhotoMemory
//
//  Created by Kant on 2023/04/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    private var memo: MemoData?
    
    // MARK: - LifeCycle
    convenience init(memo: MemoData){
        self.init()
        self.memo = memo
    }
    
    private let fullImage = UIImageView() {
        let image =
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
