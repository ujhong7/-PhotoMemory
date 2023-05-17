import UIKit

class DetailPageViewController: UIViewController {

    private let memoManager = CoreDataManager.shared

    var memoDataArray: [MemoData]?
    
    private var pageViewController: UIPageViewController!
    private var currentIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
//        view.backgroundColor = .gray
        
        configurePageViewController()
    }

    func configurePageViewController() {
        // UIPageViewController 객체 생성
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self

        // UIPageViewController 객체를 뷰에 추가
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        // UIPageViewController 레이아웃 설정
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // 첫 번째 페이지로 이동
        if let firstViewController = viewControllerAtIndex(0) {
            pageViewController.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
        }
    }

    // ⭐️
    func viewControllerAtIndex(_ index: Int) -> DetailViewController? {
        guard let memoData = memoDataArray, memoData.count > 0 else {
            return nil
        }

        // MemoDetailViewController 객체 생성
        let memoDetailViewController = DetailViewController()
        memoDetailViewController.memoData = memoData[index]
        currentIndex = index

        return memoDetailViewController
    }
}

// UIPageViewControllerDataSource 프로토콜 구현
extension DetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let memoData = memoDataArray, memoData.count > 1, let currentIndex = memoData.firstIndex(where: { $0 == (viewController as! DetailViewController).memoData }), currentIndex != 0 else {
                return nil
            }
            
            let index = (currentIndex - 1 + memoData.count) % memoData.count
            return viewControllerAtIndex(index)
        }

        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let memoData = memoDataArray, memoData.count > 1, let currentIndex = memoData.firstIndex(where: { $0 == (viewController as! DetailViewController).memoData }), currentIndex != memoData.count - 1 else {
                return nil
            }
            
            let index = (currentIndex + 1) % memoData.count
            return viewControllerAtIndex(index)
        }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        // 전체 페이지 수
        let pageCount = memoDataArray?.count ?? 0
        // 페이지 인디케이터의 전체 페이지 수 표시 색상 설정
        pageViewController.view.subviews.forEach { view in
            if let pageControl = view as? UIPageControl {
                pageControl.pageIndicatorTintColor = UIColor.lightGray
            }
        }
        return pageCount
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        // 현재 페이지 인덱스
        let index = currentIndex
        // 페이지 인디케이터의 현재 페이지 표시 색상 설정
        pageViewController.view.subviews.forEach { view in
            if let pageControl = view as? UIPageControl {
                pageControl.currentPageIndicatorTintColor = UIColor.darkGray
            }
        }
        return index
    }
    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return memoData?.count ?? 0
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentIndex
//    }
}
