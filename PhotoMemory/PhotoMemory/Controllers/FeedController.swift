//
//  FeedController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

private let reuseIdentifier = "Cell" // ⭐️

class FeedController: UICollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - CoreData
    
    let memoManager = CoreDataManager.shared
    
    var memoData: MemoData? {
        didSet {
            //
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupNaviBar()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier) // ⭐️
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier) // 🔴
    }
    
    func setupNaviBar() {
        // 네비게이션바 우측에 Plus 버튼 만들기
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    
    
    
    
    // MARK: - Actions

    // 추가하기 버튼 ⭐️
    @objc func plusButtonTapped() {
        let controller = PlusMemoryController()
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
    
}




// MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)  as! FeedCell // 🔴
        // cell.backgroundColor = .red // 🔴
        
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width = collectionView.frame.width / 3 - 1
            return CGSize(width: width, height: width)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 1
        }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = PlusMemoryController()
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: didSelectItemAt")
    }
        
}
    


