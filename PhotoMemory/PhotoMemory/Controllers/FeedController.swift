//
//  FeedController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

private let reuseIdentifier = "FeedCell" // ⭐️

class FeedController: UICollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - CoreData
    
    let memoManager = CoreDataManager.shared
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
        setupNaviBar()
    }
    
    // 델리게이트가 아닌 방식으로 구현할때는 화면 리프레시⭐️
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 다시 나타날때, 테이블뷰를 리로드
        collectionView.reloadData()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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

    // 추가하기 버튼
    @objc func plusButtonTapped() {
        let controller = PlusMemoryController()
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
    
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  memoManager.getMemoListFromCoreData().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        //cell.backgroundColor = .blue
        
        // 셀에 모델(MemoData) 전달
        let memoData = memoManager.getMemoListFromCoreData()
        cell.memoData = memoData[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(data: memoData[indexPath.row].photo!)!)
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
    
    // 셀 선택
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
        
        // MARK: - 기존 ⭐️
//        let controller = PlusMemoryController()
//        let current = memoManager.getMemoListFromCoreData()[indexPath.row]
//        controller.memoData = current
//
//        navigationController?.pushViewController(controller, animated: true)

        
        
        
        
        // TODO: - DetailViewController 띄우기
        
        let current = memoManager.getMemoListFromCoreData()[indexPath.row]
        let detailViewController = DetailViewController(memo: current)
        // ⭐️찾아보기⭐️
//        detailViewController.navigationController?.modalTransitionStyle = .coverVertical
//        detailViewController.navigationController?.modalPresentationStyle = .overFullScreen
        detailViewController.modalTransitionStyle = .coverVertical
        detailViewController.modalPresentationStyle = .fullScreen
        
        self.present(detailViewController, animated: true)
    }
          
}
    


