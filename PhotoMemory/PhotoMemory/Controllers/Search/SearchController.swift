//
//  SearchController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

private let reuseIdentifier = "FeedCell"

class SearchController: UIViewController, UISearchBarDelegate {
    // MARK: - CoreData
    let memoManager = CoreDataManager.shared
    let searchBar = UISearchBar()
    var searchResult: [MemoData] = []

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 다시 나타날때, 테이블뷰를 리로드
        collectionView.reloadData()
        // DetailViewController에서 tabBar지운거 다시 복원
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //  뷰 컨트롤러의 뷰가 서브뷰들과 함께 레이아웃을 재배치 할 때 호출되는 메소드. 이 메소드는 뷰의 크기나 위치가 변경될 때마다 호출 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        searchBar.placeholder = "검색을 통해 메모를 찾아보세요"
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func configureCollectionView() {
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(#function)
        if let searchText = searchBar.text {
              searchMemo(with: searchText)
            print("🔎 '\(searchText)'(이)가 검색되었습니다.")
          }
    }
    
    func searchMemo(with searchText: String) {
        print(#function)
        searchResult = memoManager.searchMemoListFromCoreData(with: searchText)
        collectionView.reloadData()
    }

    // 검색바에 글씨를 입력할 때마다  메소드가 호출되어 검색 결과가 업데이트
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(#function)
        print("\(searchText)✅")
         searchMemo(with: searchText)
     }
    
    // 네비게이션바 설정관련
    func setNavi() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 불투명으로
        appearance.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.modalTransitionStyle = .partialCurl
        navigationController?.modalPresentationStyle = .overFullScreen
    }
    // 검색중 화면 터치하면 키보드 내려가도록하기 !!! 🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        let memoData = searchResult
        cell.memoData = memoData[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(data: memoData[indexPath.row].photo!)!)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let current = searchResult[indexPath.row]
        let detailViewController = DetailViewController(memo: current)
        detailViewController.memoData = current
        setNavi()
        navigationController?.pushViewController(detailViewController, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SearchController: UICollectionViewDelegateFlowLayout {
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
}

// MARK: - Search
extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchMemo(with: searchText)
    }
}
