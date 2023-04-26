//
//  DetailViewController.swift
//  PhotoMemory
//
//  Created by Kant on 2023/04/24.
//

import UIKit

class DetailViewController: UIViewController {
    
//    private var memo: MemoData?
    
    let memoManager = CoreDataManager.shared
    
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
        view.backgroundColor = .yellow
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var memoTextView: UITextView = {
        let textView = UITextView()
        textView.text = memoData?.text
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark) // 블러 배경 색상을 수정하는 코드
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
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
        setGesture()
        setGesture2()
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
    func setGesture() {
        // 네비게이션 바 안보이도록 하는 제스쳐
        let naviTabHide = UITapGestureRecognizer(target: self, action: #selector(naviTabHide))
        view.addGestureRecognizer(naviTabHide)
    }
    
    func setGesture2() {
//        // 이미지 블러처리 ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//        let blurGesture = UITapGestureRecognizer(target: self, action: #selector(blurImage))
//        memoImage.isUserInteractionEnabled = true
//        memoImage.addGestureRecognizer(blurGesture)
//        
//        view.addGestureRecognizer(blurGesture)
    }
    
    // MARK: - Actions
    // Edit
    @objc func editButtonTapped() {
        let controller = PlusMemoryController(type: .editType)
        controller.memoData = self.memoData // ⭐️ 잘모르겠음..
        
        navigationController?.pushViewController(controller, animated: true)
        print("DEBUG: plusButtonTapped")
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
    
    // blur처리
//    @objc func blurImage() {
//
//        // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//        let ciImage = CIImage(data: memoData!.photo!)
//
//        let blurFilter = CIFilter(name: "CIGaussianBlur")
//        blurFilter?.setValue(ciImage, forKey: kCIInputImageKey)
//        blurFilter?.setValue(10, forKey: kCIInputRadiusKey) // blur 강도
//
//        let context = CIContext(options: nil)
//
//        if let output = blurFilter?.outputImage,
//           let blurredImage = context.createCGImage(output, from: output.extent) {
//            memoImage.image = UIImage(cgImage: blurredImage)
//        }
//        // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
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
        
        containerView.addSubview(memoTextView)
        NSLayoutConstraint.activate([
            memoTextView.centerXAnchor.constraint(equalTo: memoImage.centerXAnchor),
            memoTextView.centerYAnchor.constraint(equalTo: memoImage.centerYAnchor),
            memoTextView.widthAnchor.constraint(equalToConstant: 200),
            memoTextView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }

    
}
