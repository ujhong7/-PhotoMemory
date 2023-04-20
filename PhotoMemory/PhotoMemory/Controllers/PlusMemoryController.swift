//
//  PlusMemoryController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit
import PhotosUI


class PlusMemoryController: UITableViewController {
    
    private let plusMemoryView = PlusMemoryView()
    
    
    
    // MARK: - LifeCycle
    
    override func loadView() {
        view = plusMemoryView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        configureUI()
    }
    
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
    }
}











//extension PlusMemoryController: PHPickerViewControllerDelegate {
//
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        <#code#>
//    }
//    
//
//
//}
