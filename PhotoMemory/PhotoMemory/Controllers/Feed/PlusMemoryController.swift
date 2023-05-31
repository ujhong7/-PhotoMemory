//
//  PlusMemoryController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
import PhotosUI
import CoreData
 
protocol CalendarReloadDelegate: AnyObject {
    func reloadCalendar()
}

// 생성할때도 쓰고, 수정할때도 쓰고
enum MemoType {
    case createType
    case editType
    case none
}

weak var delegate: CalendarReloadDelegate?

class PlusMemoryController: UITableViewController {
    let memoManager = CoreDataManager.shared
    var memoType: MemoType = .none
    var memoData: MemoData?
    var currentSelectedDate: Date?
   // var delegate: CalendarControllerDelegate?
    
    // MARK: - Properties
    private lazy var memoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 5
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .systemGray5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let memoTextView: UITextView  = {
        let textView = UITextView()
        textView.backgroundColor = .systemGray6
        textView.layer.cornerRadius = 5
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - 액션 버튼을 달때 항상 lazy 키워드로 작성해주기 ⭐️
    private lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.tintColor = .black
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5 // 버튼을 둥글게 만들기 위해 cornerRadius를 조절합니다.
        button.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // (키보드 레이아웃) 애니메이션을 위한 속성
    var memoImageTopConstraint: NSLayoutConstraint!
    
    // MARK: - LifeCycle
    // ⭐️⭐️⭐️ 생성자 활용을 제대로 할 줄 알아야 데이터 넘기는 것이 편해진다.
    convenience init(type: MemoType, currentSelectedDate: Date?){
        self.init()
        self.memoType = type
        self.currentSelectedDate = currentSelectedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
            guard  memoImage.image != UIImage(systemName: "plus.circle") else { return print("이미지 없음@@") }
            guard let memoImageData = memoImage.image?.pngData() else { return print("이미지 없음")}
            
            memoManager.saveMemoData(memoText: memoText, memoPhoto: memoImageData, currentSelectedDate: currentSelectedDate) { [weak self] isValid in
                if isValid == true {
                    print("저장완료👍")
                    // 다시 전화면으로 돌아가기
                    // ⭐️⭐️⭐️ post
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ReloadCalendar"), object: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self?.navigationController?.popToRootViewController(animated: true)
                    }
                    
                } else {
                    print("저장실패")
                }
            }
        }
       
    }
    
    // 지우기 버튼
    @objc func deleteButtonTapped() {
        let alertController = UIAlertController(title: "경고", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { (action) in
            self.memoManager.deleteToDo(data: self.memoData!) {
                print("데이터 삭제 완료")
            }
            let alert = UIAlertController(title: nil, message: "메모가 삭제되었습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        self.present(alertController, animated: true, completion: nil)
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
        memoImageTopConstraint.constant = -130
          UIView.animate(withDuration: 0.2) {
              self.view.layoutIfNeeded()
          }
    }
    
    @objc func moveDownAction(){
        print(#function)
        memoImageTopConstraint.constant = 130
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
            saveButton.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 10),
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
          //  let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteButtonTapped))
            let deleteButton = UIBarButtonItem(title: "삭제", style: .plain, target: self, action: #selector(deleteButtonTapped))

            deleteButton.tintColor = .black
            navigationItem.rightBarButtonItem = deleteButton
            self.title = "메모 수정"
            memoImage.image = UIImage(data: memoData.photo!)
            guard let text = memoData.text else { return }
            memoTextView.text = text
            memoTextView.textColor = .black
            saveButton.setTitle("수정", for: .normal)
            memoTextView.becomeFirstResponder()
        } else {
            self.title = "새로운 메모"
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




