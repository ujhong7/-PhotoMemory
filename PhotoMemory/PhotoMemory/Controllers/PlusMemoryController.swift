//
//  PlusMemoryController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
import PhotosUI
import CoreData

class PlusMemoryController: UITableViewController {
    
    let memoManager = CoreDataManager.shared
    
    var memoData: MemoData?
    
    // MARK: - Properties
    
    private var plusButtonImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let memoTextField: UITextView  = {
        let tf = UITextView()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Actions
    
    @objc func handlePhotoSelect() {
        print(#function)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    @objc func saveButtonTapped() {
        print(#function)
        
        
        
        
        
        
        // 기존데이터가 있을때 ===> 기존 데이터 업데이트
        if let memoData = self.memoData {
            // 텍스트뷰에 저장되어 있는 메세지
            
            
            // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
            memoData.text = memoTextField.text
            memoData.photo = plusButtonImage?.pngData()
            
            
            memoManager.updateToDo(newToDoData: memoData) {
                print("업데이트 완료")
                // 다시 전화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
            
        // 기존데이터가 없을때 ===> 새로운 데이터 생성
        } else {
            let memoText = memoTextField.text
            guard let plusButtonImgae = plusButtonImage?.pngData() else { return print("이미지 없음")}
            
            memoManager.saveMemoData(memoText: memoText, memoPhoto: plusButtonImgae) {
                print("저장완료")
                // 다시 전화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        
        
        
        
        
    }
    
    // MARK: - LifeCycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        setContraints()
        configureUI()
        // configureUIwithData()
    }
   
    // MARK: - AutoLayout
    
    // 오토레이아웃 업데이트
    
    func setContraints() {
        
        
        view.addSubview(plusPhotoButton)
        NSLayoutConstraint.activate([
            //plusPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            //plusPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            plusPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            plusPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
//            plusPhotoButton.widthAnchor.constraint(equalToConstant: 200),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 350)
        ])


        view.addSubview(memoTextField)
        NSLayoutConstraint.activate([
            //memoTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            memoTextField.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 30),
            memoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
//            memoTextField.widthAnchor.constraint(equalToConstant: 200),
            memoTextField.heightAnchor.constraint(equalToConstant: 200)
        ])

        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([

            saveButton.topAnchor.constraint(equalTo: memoTextField.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
//            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
}


//    func configureUIwithData() {
//        memoTextField.text = momoData?.text
//    }
    



// MARK: - UIImagePickerControllerDelegate

extension PlusMemoryController:  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    // 사진 넣기 설정
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        plusButtonImage = selectedImage
        
//        plusPhotoButton.layer.cornerRadius =  plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
//        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
//        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}




