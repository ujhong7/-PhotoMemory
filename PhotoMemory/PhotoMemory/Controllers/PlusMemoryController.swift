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
    
    var memoData: MemoData?  {
        didSet {
            configureUI()
        }
    }
    
    
    // MARK: - Properties
    
    private var plusButtonImage: UIImage? // 🔴
    
    private let plusPhotoButton: UIButton = { // 🔵
        let button = UIButton(type: .system)
        button.backgroundColor = .lightGray
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePhotoSelect), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let memoTextView: UITextView  = {
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
            memoData.text = memoTextView.text
            memoData.photo = plusButtonImage?.pngData() // 🔴
            
             memoManager.updateToDo(newToDoData: memoData) {
                print("업데이트 완료")
                // 다시 전화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
            
        // 기존데이터가 없을때 ===> 새로운 데이터 생성
        } else {
            let memoText = memoTextView.text
            guard let plusButtonImgae = plusButtonImage?.pngData() else { return print("이미지 없음")} // 🔴
            
            memoManager.saveMemoData(memoText: memoText, memoPhoto: plusButtonImgae) {
                print("저장완료👍")
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
        
    }
   
    
 
    
    // 지우기 버튼
    @objc func deleteButtonTapped() {
        print("DEBUG: deleteButtonTapped")
        
        memoManager.deleteToDo(data: memoData!) {
            print("데이터 삭제 완료")
        }
        // 다시 전화면으로 돌아가기
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    
    
    
    // MARK: - AutoLayout
    
    // 오토레이아웃 업데이트
    
    func setContraints() {
        
        
        view.addSubview(plusPhotoButton) // 🔵
        NSLayoutConstraint.activate([
            plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            plusPhotoButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            plusPhotoButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            plusPhotoButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            plusPhotoButton.heightAnchor.constraint(equalToConstant: 350)
        ])


        view.addSubview(memoTextView)
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 30),
            memoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            memoTextView.heightAnchor.constraint(equalToConstant: 200)
        ])

        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([

            saveButton.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 30),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        // 기존데이터가 있을때
        if let memoData = self.memoData {
            
            // 지우기
            let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
            deleteButton.tintColor = .black
            navigationItem.rightBarButtonItem = deleteButton
            
            
            self.title = "메모 수정하기"
            
            guard let text = memoData.text else { return }
            memoTextView.text = text
            
            memoTextView.textColor = .black
            saveButton.setTitle("UPDATE", for: .normal)
            memoTextView.becomeFirstResponder()
           
            
        // 기존데이터가 없을때
        } else {
            self.title = "새로운 메모 생성하기"
            
            memoTextView.text = "텍스트를 여기에 입력하세요."
            memoTextView.textColor = .lightGray
            
        }
    }
    
    
    
}


// MARK: - UITextViewDelegate

extension PlusMemoryController: UITextViewDelegate {
    // 입력을 시작할때
    // (텍스트뷰는 플레이스홀더가 따로 있지 않아서, 플레이스 홀더처럼 동작하도록 직접 구현)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        // 비어있으면 다시 플레이스 홀더처럼 입력하기 위해서 조건 확인
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "텍스트를 여기에 입력하세요."
            textView.textColor = .lightGray
        }
    }
}


// MARK: - UIImagePickerControllerDelegate

extension PlusMemoryController:  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    // 사진 넣기 설정
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        plusButtonImage = selectedImage // 🔴 ?????????? 머냐
        
        

        plusPhotoButton.layer.masksToBounds = true // 🔵
        plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        self.dismiss(animated: true, completion: nil)
    }
}




