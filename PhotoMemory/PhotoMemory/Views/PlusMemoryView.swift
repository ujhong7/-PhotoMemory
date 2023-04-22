////
////  PlusMemory.swift
////  PhotoMemory
////
////  Created by yujaehong on 2023/04/20.
////
//
//import UIKit
//
//class PlusMemoryView: UIView {
//
//    var momoData: MemoData? {
//        didSet {
//            configureUIwithData()
//        }
//    }
//
//
//    // MARK: - Properties
//
//    private let plusPhotoButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.backgroundColor = .lightGray
//        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
//        button.tintColor = .white
//        button.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//    private let memoTextField: UITextView  = {
//        let tf = UITextView()
//        tf.translatesAutoresizingMaskIntoConstraints = false
//        return tf
//    }()
//
//    private let saveButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("SAVE", for: .normal)
//        button.tintColor = .black
//        button.backgroundColor = .lightGray
//        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//
//
//
//    // MARK: - Actions
//
//    @objc func handlePhotoSelect() {
//        print(#function)
//    }
//
//    @objc func saveButtonTapped() {
//        print(#function)
//    }
//
//    // MARK: - LifeCycle
//
//
//    override init(frame: CGRect){
//        super.init(frame: frame)
//
//        backgroundColor = .white
//
//        setContraints()
//
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//
//    // MARK: - AutoLayout
//
//    // 오토레이아웃 업데이트
//
//    func setContraints() {
//
//
//        self.addSubview(plusPhotoButton)
//        NSLayoutConstraint.activate([
//            //plusPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
//            //plusPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
//            plusPhotoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 100),
//            plusPhotoButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            plusPhotoButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
////            plusPhotoButton.widthAnchor.constraint(equalToConstant: 100),
//            plusPhotoButton.heightAnchor.constraint(equalToConstant: 350)
//        ])
//
//
//        self.addSubview(memoTextField)
//        NSLayoutConstraint.activate([
//
//            memoTextField.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 30),
//            memoTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            memoTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
////            memoTextField.widthAnchor.constraint(equalToConstant: 200),
//            memoTextField.heightAnchor.constraint(equalToConstant: 200)
//        ])
//
//
//        self.addSubview(saveButton)
//        NSLayoutConstraint.activate([
//
//            saveButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 30),
//            saveButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
//            saveButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
////            saveButton.widthAnchor.constraint(equalToConstant: 200),
//            saveButton.heightAnchor.constraint(equalToConstant: 40)
//        ])
//
//    }
//
//
//
//
//    func configureUIwithData() {
//
//        memoTextField.text = momoData?.text
//    }
//
//
//}
//
//
