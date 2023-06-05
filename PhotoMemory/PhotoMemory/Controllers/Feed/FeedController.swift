//
//  FeedController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
// import Kingfisher

private let reuseIdentifier = "FeedCell" // ⭐️

class FeedController: UICollectionViewController {
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    // MARK: - CoreData
    let memoManager = CoreDataManager.shared
    var memoData = [MemoData]()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setPlusButton()
        memoData = memoManager.getMemoListFromCoreData()
    }
    
    // 델리게이트가 아닌 방식으로 구현할때는 화면 리프레시⭐️
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 다시 나타날때, 테이블뷰를 리로드
        //collectionView.reloadData() // 🔴
        // DetailViewController에서 tabBar지운거 다시 복원
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Helpers
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier) // ⭐️
    }
    
    // 네비게이션바 우측에 Plus버튼
    func setPlusButton() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    // 네비게이션바 설정
    func setNavi() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationController?.modalTransitionStyle = .partialCurl
        navigationController?.modalPresentationStyle = .fullScreen
    }
    
    // MARK: - Actions
    @objc func plusButtonTapped() {
        // ⭐️⭐️⭐️ 생성자 관련
        let controller = PlusMemoryController(type: .createType, currentSelectedDate: nil)
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
}

// MARK: - UICollectionViewDataSource
extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memoData.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        
        loadImageAsync(data: memoData[indexPath.row].photo!) { image in
            if let image = image {
                cell.configureMemoImage(image)
            }
        }
        return cell
    }
    
    func loadImageAsync(data: Data, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
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
        // TODO: - DetailViewController 띄우기 ⭐️
        let current = memoData[indexPath.row]
        
        let detailViewController = DetailViewController(memo: current)
        
        detailViewController.memoData = current
        setNavi()
        navigationController?.pushViewController(detailViewController, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)

    }
}
    


