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
        collectionView.backgroundColor = .lightGray
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchBar()
        configureCollectionView()
    }
    //  뷰 컨트롤러의 뷰가 서브뷰들과 함께 레이아웃을 재배치 할 때 호출되는 메소드. 이 메소드는 뷰의 크기나 위치가 변경될 때마다 호출
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    private func configureSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        searchBar.placeholder = "검색어를 입력하세요"
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
        if let searchText = searchBar.text {
              searchMemo(with: searchText)
            print("🔎 '\(searchText)/(이)가 검색되었습니다.")
          }
    }
    
    
    func searchMemo(with searchText: String) {
        searchResult = memoManager.searchMemoListFromCoreData(with: searchText)
        collectionView.reloadData()
    }

    
}

extension SearchController: UICollectionViewDelegate, UICollectionViewDataSource {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        //cell.backgroundColor = .blue
        
        // 셀에 모델(MemoData) 전달
        let memoData = memoManager.getMemoListFromCoreData()
        cell.memoData = memoData[indexPath.row]
        cell.backgroundView = UIImageView(image: UIImage(data: memoData[indexPath.row].photo!)!)
        return cell
    }
    
    // 추가 메서드
    
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
