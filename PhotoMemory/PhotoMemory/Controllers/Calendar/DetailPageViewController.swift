import UIKit

// DetailPageViewController, NoDataPageViewController 가 어떤 부분이 달라야하는가?
// UI 가 달라야한다.
// DetailPageVC가 그려지면 NoDataPageVC는 그려지지 않고
// NoDataPageVC가 그려지면 DetailPageVC는 그려지지 않는다.
// 둘 중 하나만 그려지고 오토레이아웃을 잡아줘야 한다.
// 그런데 이 두가지 중 하나를 선택하는 판단의 기준이 뭘까?
// 네이밍에서 알 수 있듯이 데이터의 유무.
// 사용자가 캘린더에서 원하는 날짜를 클릭했을때 DetailPageViewController 로 진입할 수 있게 해주고
// viewDidLoad() 에서 memoDataArray 값이 있는지 없는지를 확인해준다.
// 있다면 HaveData의 값은 yesData가 될 것이고 없다면 noData가 된다.
// HaveData 타입의 객체를 하나 만들어주는 것이 핵심.
// (memoDataArray 값은 CalendarController 파일 Line 297 을 보면 알 수 있다.)


enum HaveData {
    case yesData
    case noData
    case none
}


class DetailPageViewController: UIViewController {
    private let memoManager = CoreDataManager.shared
    
    var haveData: HaveData = .none // 이런식으로 enum 타입 객체를 하나 선언해준다.
    
    var memoDataArray: [MemoData]?
    var currentSelectedDate: Date?

    
    private var pageViewController: UIPageViewController!
    private var currentIndex: Int = 0
    
    // NoDataPageViewController 에서 가져온 것
    private lazy var noDataLabel: UILabel = {
        let label = UILabel()
        label.text = "저장된 메모가 없습니다"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        
        if let memoDataArray = memoDataArray {
            haveData = memoDataArray.isEmpty ? .noData : .yesData // 삼항연산자에 대해 찾아보고 이해해보기
        }
        
        if haveData == .yesData {
            configurePageViewController()
            setupNaviBar()
        } else {
            setPlusButton()
            view.addSubview(noDataLabel)
            setContraints()
        }
    }

    func setupNaviBar() {
//        // 네비게이션바 우측에 Plus 버튼 만들기
//        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
//        editButton.tintColor = .black
//        navigationItem.rightBarButtonItem = editButton
        
        // 첫 번째 버튼
        let editButton = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .black
        
        // 두 번째 버튼
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped))
        plusButton.tintColor = .black
        
        // 네비게이션바 우측에 두 개의 버튼 추가
        navigationItem.rightBarButtonItems = [plusButton, editButton]
    }
    
    @objc func editButtonTapped() {
        // ⭐️⭐️⭐️ 생성자 관련
        let controller = PlusMemoryController(type: .editType, currentSelectedDate: nil)
        // controller.memoData = self.memoData // ⭐️ 잘모르겠음..
        // controller.memoData = memoDataArray?[currentIndex]
        if let selectedViewController = pageViewController.viewControllers?.first as? DetailViewController,
             let selectedMemoData = selectedViewController.memoData {
              controller.memoData = selectedMemoData
          }
        navigationController?.pushViewController(controller, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        print("DEBUG: plusButtonTapped")
    }
    
    @objc func plusButtonTapped() {
        let controller = PlusMemoryController(type: .createType, currentSelectedDate: currentSelectedDate)
        navigationController?.pushViewController(controller, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        print("DEBUG: plusButtonTapped")
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
    
    // MARK: - NoDataPageViewController 에서 사용한 메서드 그대로 가져온 것
    func setPlusButton() {
        let plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTappedNoDataUI))
        plusButton.tintColor = .black
        navigationItem.rightBarButtonItem = plusButton
    }
    
    @objc func plusButtonTappedNoDataUI() {
        let controller = PlusMemoryController(type: .createType, currentSelectedDate: currentSelectedDate)
        navigationController?.pushViewController(controller, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "뒤로가기", style: .plain, target: nil, action: nil)
        print("DEBUG: plusButtonTapped")
    }
    
    func setContraints() {
        // UILabel을 수평 및 수직 중앙에 위치시키는 제약 조건 추가
        NSLayoutConstraint.activate([
            noDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
}
