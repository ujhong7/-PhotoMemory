//
//  OnboardingViewController.swift
//  PhotoMemory
//
//  Created by yujaehong on 2023/06/07.
//



import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var startButton: UIButton!

    let images = ["play", "list", "grid"]
    let titles = ["Welcome to MyApp!", "Discover amazing features!", "Get started now!"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScrollView()
        setupPageControl()
        view.backgroundColor = .green
    }

    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)
        
        for i in 0..<images.count {
            let frame = CGRect(x: view.bounds.width * CGFloat(i), y: 0, width: view.bounds.width, height: view.bounds.height)
            let contentView = createContentView(frame: frame, imageName: images[i], title: titles[i])
            scrollView.addSubview(contentView)
        }
        
        view.addSubview(scrollView)
    }

    func createContentView(frame: CGRect, imageName: String, title: String) -> UIView {
        let contentView = UIView(frame: frame)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 100, width: frame.width, height: 200))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: imageName)
        contentView.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: imageView.frame.maxY + 20, width: frame.width - 40, height: 30))
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.text = title
        contentView.addSubview(titleLabel)
        
        return contentView
    }

    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)
        
        view.addSubview(pageControl)
    }
    
    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let offsetX = CGFloat(currentPage) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        
        if pageIndex == CGFloat(images.count - 1) {
            showStartButton()
        } else {
            hideStartButton()
        }
    }
    
    func showStartButton() {
        if startButton == nil {
            startButton = UIButton(type: .system)
            startButton.setTitle("Get Started", for: .normal)
            startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            startButton.frame = CGRect(x: 20, y: view.bounds.height - 150, width: view.bounds.width - 40, height: 50)
            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            
            view.addSubview(startButton)
        }
    }
    
    func hideStartButton() {
        startButton?.removeFromSuperview()
        startButton = nil
    }
    
    @objc func startButtonTapped() {
        
        //  최초 실행 여부 UserDefaults에 저장
        UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
        UserDefaults.standard.synchronize()
        
        // Perform transition to MainTabController
        let mainTabController = MainTabController()
        mainTabController.modalPresentationStyle = .fullScreen
        present(mainTabController, animated: true, completion: nil)
    }
    
    
}
