//
//  PlusMemoryController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
import PhotosUI
import CoreData

// 생성할때도 쓰고, 수정할때도 쓰고

enum MemoType {
    case createType
    case editType
    case none
}

class PlusMemoryController: UITableViewController {
    
    let memoManager = CoreDataManager.shared
    
    var memoData: MemoData?  {
        didSet {
            configureUI()
        }
    }
    
    var memoType: MemoType = .none
    
    // MARK: - Properties
    
    private lazy var memoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "plus_photo")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let memoTextView: UITextView  = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let addressTextView: UITextView  = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - 액션 버튼을 달때 항상 lazy 키워드로 작성해주기 ⭐️
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SAVE", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - LifeCycle
    convenience init(type: MemoType){
        self.init()
        self.memoType = type
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setContraints()
        configureUI()
        setGesture()
        memoTextView.delegate = self
    }
    
    func setGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handlePhotoSelect))
        memoImage.isUserInteractionEnabled = true
        memoImage.addGestureRecognizer(tapGesture)
    }
    
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
            memoData.text = memoTextView.text
            memoData.photo = memoImage.image?.pngData()
            
            memoManager.updateToDo(newToDoData: memoData) {
                
                // 다시 전화면으로 돌아가기
                print(#fileID, #function, #line, "칸트")
                self.navigationController?.popViewController(animated: true) // 🔵
                // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
                // 수정하고 pop했을때 detailVC로 가는게 아니라 detailVC 거치고 PlusMemortController로 간다.. 뭐가 잘못일까 🔴
                // edit들어가서 ->  삭제  -> 삭제는되는데 detailVC 화면뜸 -> 여기서 edit 누르면 앱죽음.. 🔴
                // ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️

            }
             
        // 기존데이터가 없을때 ===> 새로운 데이터 생성
        } else {
            let memoText = memoTextView.text
            guard  memoImage.image != UIImage(named: "plus_photo") else { return print("이미지 없음") }
            guard let memoImageData = memoImage.image?.pngData() else { return print("이미지 없음")}
            // 🔴 이미지가 늘 설정되어있기 때문에 이미지가 없을수가 없다.......
            
            memoManager.saveMemoData(memoText: memoText, memoPhoto: memoImageData) { [weak self] isValid in
                if isValid == true {
                    print("저장완료👍")
                    // 다시 전화면으로 돌아가기
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    print("저장실패")
                }
            }
        }
        
        // TODO: - init 생성자를 추가해서 코드 변경하기
        if memoType == .createType {
            
        } else if memoType == .editType {
            
        }
    }
    
    // 지우기 버튼
    @objc func deleteButtonTapped() {
        print("DEBUG: deleteButtonTapped")
        
        memoManager.deleteToDo(data: memoData!) {
            print("데이터 삭제 완료")
        }
        // 다시 전화면으로 돌아가기
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - AutoLayout
    
    func setContraints() {
        view.addSubview(memoImage)
        NSLayoutConstraint.activate([
            memoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            memoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            memoImage.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        view.addSubview(memoTextView)
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: memoImage.bottomAnchor, constant: 30),
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
            
            memoImage.image = UIImage(data: memoData.photo!)
            
            guard let text = memoData.text else { return }
            memoTextView.text = text
            memoTextView.textColor = .black
            saveButton.setTitle("UPDATE", for: .normal)
            memoTextView.becomeFirstResponder()
        } else {
            self.title = "새로운 메모 생성하기"
            memoTextView.text = "텍스트를 여기에 입력하세요."
            memoTextView.textColor = .lightGray
        }
    }
//
//    // 다른 곳을 터치하면 키보드 내리기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        view.endEditing(true)
//    }
    
}


// MARK: - UITextViewDelegate

extension PlusMemoryController: UITextViewDelegate {
    // 입력을 시작할때
    // (텍스트뷰는 플레이스홀더가 따로 있지 않아서, 플레이스 홀더처럼 동작하도록 직접 구현)
    
    // TODO: - 키보드 올라올때 텍스트창 위로 올라갈 수 있도록. 입력 종료되면 기존값으로 돌아가기
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = ""
            textView.textColor = .black
        }
        
        // TODO: - 생각해볼것
        // 이름(5자미만 가능하개), 주소(@gmail.com)
//        switch textView {
//        case memoTextView:
//
//        case addressTextView:
//
//        default
//            break
//        }
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
        
        memoImage.image = selectedImage
        
        self.dismiss(animated: true, completion: nil)
    }
}




