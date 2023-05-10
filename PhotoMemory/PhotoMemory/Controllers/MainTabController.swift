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
        view.backgroundColor = .white
        
        let layout = UICollectionViewFlowLayout()
        
       
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), slectedImage: #imageLiteral(resourceName: "home_selected"), rootviewController: FeedController(collectionViewLayout: layout))
        let second = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), slectedImage: #imageLiteral(resourceName: "like_selected"), rootviewController: secondController())
        let calendar = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), slectedImage: #imageLiteral(resourceName: "plus_unselected"), rootviewController: CalendarController())
        let fourth = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), slectedImage: #imageLiteral(resourceName: "search_selected"), rootviewController: SearchController())
        
        
        viewControllers = [feed, second, calendar, fourth]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, slectedImage: UIImage, rootviewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootviewController)
    
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.image = slectedImage
        nav.navigationBar.tintColor = .black

        return nav
    }
    
}
