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
    var memoType: MemoType = .none
    var memoData: MemoData?  {
        didSet {
            configureUI()
        }
    }
    
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
    
    // (키보드 레이아웃) 애니메이션을 위한 속성
    var memoImageTopConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    convenience init(type: MemoType){
        self.init()
        self.memoType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        setContraints()
        configureUI()
        setGesture()
        setupNotification()
        memoTextView.delegate = self
    }
    
    func setGesture() {
        let photoSelectGesture = UITapGestureRecognizer(target: self, action: #selector(photoSelect))
        memoImage.isUserInteractionEnabled = true
        memoImage.addGestureRecognizer(photoSelectGesture)
        let dismissKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(dismissKeyboardGesture)
    }
    
    // MARK: - Actions
    @objc func photoSelect() {
        print(#function)
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func saveButtonTapped() {
        print(#function)
        // 기존데이터가 있을때 ===> 기존 데이터 업데이트 (edit)
        if let memoData = self.memoData {
            // 텍스트뷰에 저장되어 있는 메세지
            memoData.text = memoTextView.text
            memoData.photo = memoImage.image?.pngData()
            
            memoManager.updateToDo(newToDoData: memoData) {
                
                // 다시 전화면으로 돌아가기
                print(#fileID, #function, #line, "칸트")
                self.navigationController?.popToRootViewController(animated: true)
            }
             
        // 기존데이터가 없을때 ===> 새로운 데이터 생성
        } else {
            let memoText = memoTextView.text
            guard memoText != "텍스트를 여기에 입력하세요." else { return print("텍스트를 입력하세요.")}
            guard  memoImage.image != UIImage(named: "plus_photo") else { return print("이미지 없음") }
            guard let memoImageData = memoImage.image?.pngData() else { return print("이미지 없음")}
            
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
        print(#function)
        memoManager.deleteToDo(data: memoData!) {
            print("데이터 삭제 완료")
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // TODO: - 노티피케이션 셋팅 (키보드)
    func setupNotification(){
        print(#function)
        // 노티피케이션의 등록
        // (OS차원에서 어떤 노티피케이션이 발생하는지 이미 정해져 있음)
        NotificationCenter.default.addObserver(self, selector: #selector(moveUpAction),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(moveDownAction),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func moveUpAction(){
        print(#function)
        memoImageTopConstraint.constant = -30
          UIView.animate(withDuration: 0.2) {
              self.view.layoutIfNeeded()
          }
    }
    
    @objc func moveDownAction(){
        print(#function)
        memoImageTopConstraint.constant = 30
           UIView.animate(withDuration: 0.2) {
               self.view.layoutIfNeeded()
           }
    }
    
    // MARK: - 소멸자 구현
    // 옵저버 객체 사라질 수 있도록
    deinit{
        // 노티피케이션의 등록 해제 (해제안하면 계속 등록될 수 있음) ⭐️
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - AutoLayout
    func setContraints() {
        view.addSubview(memoImage)
        NSLayoutConstraint.activate([
            memoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20), // ⭐️
            memoImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            memoImage.heightAnchor.constraint(equalToConstant: 350)
        ])
        
        view.addSubview(memoTextView)
        NSLayoutConstraint.activate([
            memoTextView.topAnchor.constraint(equalTo: memoImage.bottomAnchor, constant: 20),
            memoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            memoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            memoTextView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        view.addSubview(saveButton)
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30),
            saveButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        memoImageTopConstraint = memoImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 20)

        NSLayoutConstraint.activate([
            memoImageTopConstraint,
            view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
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

    // 다른 곳을 터치하면 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - UITextViewDelegate
extension PlusMemoryController: UITextViewDelegate {
    // (텍스트뷰는 플레이스홀더가 따로 있지 않아서, 플레이스 홀더처럼 동작하도록 직접 구현)
    // TODO: - 키보드 올라올때 텍스트창 위로 올라갈 수 있도록. 입력 종료되면 기존값으로 돌아가기
    // 입력시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "텍스트를 여기에 입력하세요." {
            textView.text = ""
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
        memoImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
}




