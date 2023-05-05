//
//  thirdController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//  0502 ~

import UIKit

final class CalendarController: UIViewController {
    
    // MARK: - CoreData
    let memoManager = CoreDataManager.shared
    
   // MARK: - Properties
    private lazy var scrollView = UIScrollView() // 작은화면에서도 잘리지 않고 잘 보였으면 해서 생성....?
    private lazy var contentView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var previousButton = UIButton()
    private lazy var nextButton = UIButton()
    private lazy var todayButton = UIButton()
    private lazy var weekStackView = UIStackView()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter() // 전역변수 ⭐️
    private var calendarDate = Date()
    private var days = [String]()
    
    // MARK: - MemoData ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
    private var memo: [MemoData] = [MemoData]() // 새로운 객체 생성이자 전역변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        fetchMemo() // fetch 라는건 보통은 API 호출을 통해서 가지고 오는 데이터를 작성할때 사용하는 메서드
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 뷰가 다시 나타날때, 테이블뷰를 리로드
        collectionView.reloadData()
        // DetailViewController에서 tabBar지운거 다시 복원
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func fetchMemo() {
        memo = memoManager.getMemoListFromCoreData()
    }
    
    private func configure() {
       conmfigureScrollView()
       configureContentView()
       configureTitleLabel()
       configurePreviousButton()
       configureNextButton()
       configureTodayButton()
       configureWeekStackView()
       configureWeekLabel()
       configureCollectionView()
       configureCalendar()
    }
    
    private func conmfigureScrollView() {
       view.addSubview(scrollView)
       scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
       scrollView.addSubview(contentView)
       contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
           contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
           contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
           contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
           contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor)
        ])
    }
    
    private func configureTitleLabel() {
       contentView.addSubview(titleLabel)
       // titleLabel.text = "2000년 1월"
       titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .bold)
       titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           titleLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
           titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        ])
    }
    
    private func configurePreviousButton() {
       contentView.addSubview(previousButton)
       previousButton.tintColor = .label
       previousButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
       previousButton.addTarget(self, action: #selector(didPreviousButtonTapped), for: .touchUpInside)
       previousButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           previousButton.widthAnchor.constraint(equalToConstant: 44),
           previousButton.heightAnchor.constraint(equalToConstant: 44),
           previousButton.trailingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor, constant: -5),
           previousButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureNextButton() {
        contentView.addSubview(nextButton)
        nextButton.tintColor = .label
        nextButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        nextButton.addTarget(self, action: #selector(didNextButtonTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           nextButton.widthAnchor.constraint(equalToConstant: 44),
           nextButton.heightAnchor.constraint(equalToConstant: 44),
           nextButton.leadingAnchor.constraint(equalTo: self.titleLabel.trailingAnchor, constant: 5),
           nextButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureTodayButton() {
       contentView.addSubview(todayButton)
       todayButton.setTitle("Today", for: .normal)
       todayButton.setTitleColor(.systemBackground, for: .normal)
       todayButton.backgroundColor = .label
       todayButton.layer.cornerRadius = 5
       todayButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           todayButton.widthAnchor.constraint(equalToConstant: 60),
           todayButton.heightAnchor.constraint(equalToConstant: 30),
           todayButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
           todayButton.centerYAnchor.constraint(equalTo: self.titleLabel.centerYAnchor)
        ])
    }
    
    private func configureWeekStackView() {
       contentView.addSubview(weekStackView)
       weekStackView.distribution = .fillEqually
       weekStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
           weekStackView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 40),
           weekStackView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
           weekStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -5)
        ])
    }
    
    private func configureWeekLabel() {
        let dayOfTheWeek = ["일", "월", "화", "수", "목", "금", "토"]
        
        for i in 0..<7 {
            let label = UILabel()
            label.text = dayOfTheWeek[i]
            label.textAlignment = .center
            self.weekStackView.addArrangedSubview(label)
            
            if i == 0 {
                label.textColor = .systemRed
            } else if i == 6 {
                label.textColor = .systemBlue
            }
        }
    }
    
    private func configureCollectionView() {
        contentView.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: weekStackView.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: weekStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: weekStackView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor, multiplier: 1.5), // multiplier?
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: - Actions
    @objc private func didPreviousButtonTapped(_ sender: UIButton) {
        minusMonth()
    }
    
    @objc private func didNextButtonTapped(_ sender: UIButton) {
        plusMonth()
    }
}
    // MARK: - Extension
extension CalendarController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    // ⭐️⭐️⭐️ 내가 원하는대로 셀을 커스텀하고 싶을땐? -> cellForItemAt 을 통해 접근해보기
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as? CalendarCollectionViewCell else { return UICollectionViewCell() }

        cell.update(day: days[indexPath.item])
        
        // TODO: - date
        let customDateFormatter = DateFormatter() // 지역변수 ⭐️
        customDateFormatter.dateFormat = "d"
        
        // 이거는 현재 캘린더의 날짜를 확인할 수 있는 코드
        //let date = customDateFormatter.string(from: self.calendarDate)
        //print(#fileID, #function, #line, "현재의 날짜, date: \(date)")
        
        // 코어데이터 메모에 저장된 날짜는 Date() 타입
        // 현재 작업된건 String 타입
        // Date() vs Date() 비교는 뭔가 애매한 점이 있음
        
        //customDateFormatter.string(from: memo[indexPath.row].date!)
        
        // indexPath.row 갯수는 days.count 만큼 숫자가 증가하는것
        // 메모데이터 0
        // 메모데이터 1
        // 메모데이터 2
        // 메모데이터 3
        // 메모데이터 4
        // 메모데이터 5
        // 메모데이터 6 <- index Error
        
        var checkValue: Int = 0
        
        if memo.count != checkValue {
            for memoData in memo {
                if let savedDate = memoData.date, days[indexPath.item] == customDateFormatter.string(from: savedDate) {
                    cell.existData()
                    checkValue += 1
                }
            }
        }
        return cell
    }
    
    // 셀 크기
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = weekStackView.frame.width / 7
        return CGSize(width: width, height: width * 1.3)
    }
    
    // 셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    // 셀 선택 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         
         // 메모에 날짜 데이터가 없으면? 그냥 종료해버려
         guard memo[indexPath.row].date != nil else { return }
         
         
         // 그게 아니라면 선택된 셀에 대한 로직을 넣어줘
         
         // date를 기준으로..선택
         // 셀이 선택된 경우 <메모가 기록된 날, 기록되지 않은 날> 두 가지 케이스로 나뉨
//         if indexPath.row < memoManager.getMemoListFromCoreData().count {
//                // 데이터가 있는 셀 클릭한 경우
//                let current = memoManager.getMemoListFromCoreData()[indexPath.row]
//                let detailViewController = DetailViewController(memo: current)
//                detailViewController.memoData = current
//
//                navigationController?.modalTransitionStyle = .partialCurl
//                navigationController?.modalPresentationStyle = .overFullScreen
//                navigationController?.pushViewController(detailViewController, animated: true)
//            } else {
//                // 데이터가 없는 셀 클릭한 경우
//                let noDataViewController = NoDataViewController()
//                navigationController?.modalTransitionStyle = .partialCurl
//                navigationController?.modalPresentationStyle = .overFullScreen
//                navigationController?.pushViewController(noDataViewController, animated: true)
//            }
    }
    
}
    

extension CalendarController {
    private func configureCalendar() {
        let components = self.calendar.dateComponents([.year, .month], from: Date())
          self.calendarDate = self.calendar.date(from: components) ?? Date()
          self.dateFormatter.dateFormat = "yyyy년 MM월"
          self.updateCalendar()
      }
      
      private func startDayOfTheWeek() -> Int {
          return self.calendar.component(.weekday, from: self.calendarDate) - 1
      }
      
      private func endDate() -> Int {
          return self.calendar.range(of: .day, in: .month, for: self.calendarDate)?.count ?? Int()
      }
      
      private func updateCalendar() {
          self.updateTitle()
          self.updateDays()
      }
      
      private func updateTitle() {
          let date = self.dateFormatter.string(from: self.calendarDate)
          self.titleLabel.text = date
      }
      
      private func updateDays() {
          self.days.removeAll()
          let startDayOfTheWeek = self.startDayOfTheWeek()
          let totalDays = startDayOfTheWeek + self.endDate()
          
          for day in Int()..<totalDays {
              if day < startDayOfTheWeek {
                  self.days.append(String())
                  continue
              }
              self.days.append("\(day - startDayOfTheWeek + 1)")
          }
          self.collectionView.reloadData()
      }
      
      private func minusMonth() {
          self.calendarDate = self.calendar.date(byAdding: DateComponents(month: -1), to: self.calendarDate) ?? Date()
          self.updateCalendar()
      }
      
      private func plusMonth() {
          self.calendarDate = self.calendar.date(byAdding: DateComponents(month: 1), to: self.calendarDate) ?? Date()
          self.updateCalendar()
      }
}

    
    

