//
//  DetailViewController.swift
//  PhotoMemory
//
//  Created by Kant on 2023/04/24.
//

import UIKit

final class DetailViewController: UIViewController {
//    private var memo: MemoData?
    private let memoManager = CoreDataManager.shared
    
    var memoData: MemoData?  {
        didSet {
            // configureUI()
        }
    }
    
    // MARK: - Properties
    private lazy var memoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(data: memoData!.photo!) // ⭐️ 잘모르겠음..
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.text = memoData?.text
        let font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = font
        textView.backgroundColor = .clear
        let textColor = UIColor.black
        textView.textColor = textColor
        
        // NSAttributedString 생성 (폰트 테두리)
          let attributes: [NSAttributedString.Key: Any] = [
              .font: font,
              .foregroundColor: textColor,
              .strokeColor: UIColor.black, // 테두리 색상
              .strokeWidth: -3.0 // 음수 값으로 설정하면 테두리가 채워짐
          ]
          let attributedString = NSAttributedString(string: textView.text ?? "", attributes: attributes)
          
          textView.attributedText = attributedString
        
        textView.isEditable = false
        textView.alpha = 0.0
        textView.isHidden = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        if let date = memoData?.date {
            label.text = formatter.string(from: date)
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular) // 블러 배경 색상을 수정하는 코드
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.alpha = 0.0
        visualEffectView.isHidden = true
        return visualEffectView
    }()
    
    // MARK: - LifeCycle
    convenience init(memo: MemoData){
        self.init()
        self.memoData = memo
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setContraints()
        setupPlusNaviBar()
        // setGestureNavi()
        setGestureTextView()
    }
    
    deinit {
        print(#fileID, #function, #line, "칸트")
    }
    
    // MARK: - setup
    func setupPlusNaviBar() {
        // 네비게이션바 우측에 Plus 버튼 만들기
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
    }
    
    // MARK: - setGesture
//    func setGestureNavi() {
//        // 네비게이션 바 안보이도록 하는 제스쳐
//        let naviTabHide = UITapGestureRecognizer(target: self, action: #selector(naviTabHide))
//        view.addGestureRecognizer(naviTabHide)
//    }
    
    func setGestureTextView() {
        // TextView 가리기 on/off
        let textHideButton = UITapGestureRecognizer(target: self, action: #selector(textHideSelector))
        containerView.addGestureRecognizer(textHideButton)
    }
    
    // MARK: - Actions
    @objc func editButtonTapped() {
        let controller = PlusMemoryController(type: .editType)
        controller.memoData = self.memoData // ⭐️ 잘모르겠음..
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
        
    // 텍스트 숨기기 제스쳐
    @objc func textHideSelector() {
        let duration = 0.7
        let textDuration = 1.0
        
        // ⭐️ 추가 공부 필요 !!
        if blurEffectView.alpha == 0.0 {
            blurEffectView.isHidden = false
            UIView.animate(withDuration: duration) {
                self.blurEffectView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: duration) {
                self.blurEffectView.alpha = 0.0
            } completion: { _ in
                self.blurEffectView.isHidden = true
            }
        }

        if memoTextView.alpha == 0.0 {
            memoTextView.isHidden = false
            UIView.animate(withDuration: textDuration) {
                self.memoTextView.alpha = 1.0
            }
        } else {
            UIView.animate(withDuration: textDuration) {
                self.memoTextView.alpha = 0.0
            } completion: { _ in
                self.memoTextView.isHidden = true
            }
        }
    }
    
//    // 네비게이션 바 숨기기 제스쳐
//    @objc func naviTabHide() {
//        // 네비게이션 바가 숨겨져 있는 경우 보이도록 함
//        if navigationController?.isNavigationBarHidden == true {
//            navigationController?.setNavigationBarHidden(false, animated: true)
//        }
//        // 네비게이션 바가 보이는 경우 숨기도록 함
//        else {
//            navigationController?.setNavigationBarHidden(true, animated: true)
//        }
//    }
    
    // MARK: - AutoLayout
    func setContraints() {
        view.addSubview(memoImage)
        NSLayoutConstraint.activate([
            memoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            memoImage.widthAnchor.constraint(equalToConstant: 400),
            memoImage.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        view.addSubview(dateLabel)
           NSLayoutConstraint.activate([
               dateLabel.bottomAnchor.constraint(equalTo: memoImage.topAnchor, constant: -5),
               dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
           ])
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 400),
            containerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        containerView.addSubview(blurEffectView)
        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        containerView.addSubview(memoTextView)
        NSLayoutConstraint.activate([
            memoTextView.centerXAnchor.constraint(equalTo: memoImage.centerXAnchor),
            memoTextView.centerYAnchor.constraint(equalTo: memoImage.centerYAnchor),
            memoTextView.widthAnchor.constraint(equalToConstant: 315),
            memoTextView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
