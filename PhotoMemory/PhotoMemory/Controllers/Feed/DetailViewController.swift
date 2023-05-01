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
//        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
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
        
    
        // 편집 불가능하도록 설정
        textView.isEditable = false
        
        textView.alpha = 0.0
        textView.isHidden = true
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemChromeMaterialDark) // 블러 배경 색상을 수정하는 코드
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = view.frame
        // 초기값blur 꺼두기
        
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
        setupNaviBar()
        setGestureNavi()
        setGestureTextView()
    }
    
    deinit {
        print(#fileID, #function, #line, "칸트")
    }
    
    // MARK: - Helpers
    
    func setupNaviBar() {
        // 네비게이션바 우측에 Plus 버튼 만들기
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .black
        navigationItem.rightBarButtonItem = editButton
    }
    
    // MARK: - setGesture
    func setGestureNavi() {
        // 네비게이션 바 안보이도록 하는 제스쳐
        let naviTabHide = UITapGestureRecognizer(target: self, action: #selector(naviTabHide))
        view.addGestureRecognizer(naviTabHide)
        
        
    }
    
    func setGestureTextView() {
        // TextView 가리기 on/off
        let textHideButton = UITapGestureRecognizer(target: self, action: #selector(textHideSelector))
        containerView.addGestureRecognizer(textHideButton)
//memoTextView.addGestureRecognizer(textHideButton)
        
//        alpha속성을 사용해서 hide하기
//        memoTextView.alpha = 1
//        memoTextView.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    // Edit
    @objc func editButtonTapped() {
        let controller = PlusMemoryController(type: .editType)
        controller.memoData = self.memoData // ⭐️ 잘모르겠음..
        
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
    }
    
//    // 텍스트 숨기기 제스쳐
//    @objc func textHideSelector() {
////        memoTextView.isHidden.toggle()
////        blurEffectView.isHidden.toggle()
//
//        UIView.animate(withDuration: 3) {
//            self.memoTextView.isHidden.toggle()
//            self.blurEffectView.isHidden.toggle()
//        }
//
//
////        alpha속성을 사용해서 hide하기
////        memoTextView.alpha = memoTextView.alpha == 0 ? 1 : 0
////        memoTextView.isUserInteractionEnabled = !memoTextView.isUserInteractionEnabled
//    }
    
    // 텍스트 숨기기 제스쳐
    @objc func textHideSelector() {
        let duration = 3.0
        let textDuration = 1.0
        
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
    
    // 네비게이션 바 숨기기 제스쳐
    @objc func naviTabHide() {
        // view.backgroundColor = .yellow
        
        // 네비게이션 바가 숨겨져 있는 경우 보이도록 함
        if navigationController?.isNavigationBarHidden == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        // 네비게이션 바가 보이는 경우 숨기도록 함
        else {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
    }
        
   
    
    // 화면 터치 키보드 내리기 (첫번째 responder가 될수 있는것 종료)
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.endEditing(true)
//    }
    
    // MARK: - AutoLayout
    func setContraints() {
        view.addSubview(memoImage)
        NSLayoutConstraint.activate([
            // 위치
            memoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // 크기
            memoImage.widthAnchor.constraint(equalToConstant: 400),
            memoImage.heightAnchor.constraint(equalToConstant: 400)
        ])
//        view.addSubview(memoTextView)
//        NSLayoutConstraint.activate([
//            // 위치
//            memoTextView.centerXAnchor.constraint(equalTo: memoImage.centerXAnchor),
//            memoTextView.centerYAnchor.constraint(equalTo: memoImage.centerYAnchor),
//            // 크기
//            memoTextView.widthAnchor.constraint(equalToConstant: 200),
//            memoTextView.heightAnchor.constraint(equalToConstant: 200)
//        ])
//
//        view.addSubview(blurEffectView)
//        NSLayoutConstraint.activate([
//            blurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            blurEffectView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            blurEffectView.widthAnchor.constraint(equalToConstant: 400),
//            blurEffectView.heightAnchor.constraint(equalToConstant: 400)
//        ])
        
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
