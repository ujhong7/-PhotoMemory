//
//  MainTabController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/04/20.
//

import UIKit

class MainTabController: UITabBarController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helpers
    func configureViewControllers() {
        view.backgroundColor = .green
        let layout = UICollectionViewFlowLayout()
        
        let feed = templateNavigationController(unselectedImage: UIImage(systemName: "square.stack")!, slectedImage: UIImage(systemName: "square.stack.fill")!, rootviewController: FeedController(collectionViewLayout: layout))
        // let second = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), slectedImage: #imageLiteral(resourceName: "like_selected"), rootviewController: secondController())
        let calendar = templateNavigationController(unselectedImage: UIImage(systemName: "calendar.circle")!, slectedImage: UIImage(systemName: "calendar.circle.fill")!, rootviewController: CalendarController())
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), slectedImage: #imageLiteral(resourceName: "search_selected"), rootviewController: SearchController())
        
        viewControllers = [feed, calendar, search]
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, slectedImage: UIImage, rootviewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootviewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = slectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
}
