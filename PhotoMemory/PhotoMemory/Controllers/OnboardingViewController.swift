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

    let images = ["SC1", "SC2", "SC3", "SC4", "SC5", "SC6"]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScrollView()
        setupPageControl()
        view.backgroundColor = .white
    }

    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: scrollView.bounds.height)

        for i in 0..<images.count {
            let frame = CGRect(x: view.bounds.width * CGFloat(i), y: 0, width: view.bounds.width, height: view.bounds.height)
            let contentView = createContentView(frame: frame, imageName: images[i])
            scrollView.addSubview(contentView)
        }

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func createContentView(frame: CGRect, imageName: String) -> UIView {
        let contentView = UIView(frame: frame)
        //let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: imageName)
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])

        return contentView
    }

    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.tintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.addTarget(self, action: #selector(pageControlValueChanged(_:)), for: .valueChanged)

        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.widthAnchor.constraint(equalToConstant: view.bounds.width),
            pageControl.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc func pageControlValueChanged(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        let offsetX = CGFloat(currentPage) * view.bounds.width
        scrollView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / scrollView.bounds.width)
        pageControl.currentPage = Int(pageIndex)
        
        pageIndex == CGFloat(images.count - 1) ? showStartButton() : hideStartButton()
        
        if pageIndex == 0 {
            scrollView.isScrollEnabled = scrollView.contentOffset.x >= 0
        } else {
            scrollView.isScrollEnabled = true
        }

        let maxOffsetX = scrollView.contentSize.width - scrollView.bounds.width
        if pageIndex == CGFloat(images.count - 1) {
            scrollView.isScrollEnabled = scrollView.contentOffset.x <= maxOffsetX
        }
    }

    func showStartButton() {
        if startButton == nil {
            let lastPageIndex = images.count - 1
            let lastPageFrame = CGRect(x: view.bounds.width * CGFloat(lastPageIndex), y: 0, width: view.bounds.width, height: view.bounds.height)

            let contentView = createContentView(frame: lastPageFrame, imageName: images[lastPageIndex])
            startButton = UIButton(type: .system)
            startButton.translatesAutoresizingMaskIntoConstraints = false
            startButton.setTitle("시작하기", for: .normal)
            startButton.layer.cornerRadius = 5
            startButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            startButton.frame = CGRect(x: 20, y: view.bounds.height - 150, width: view.bounds.width - 40, height: 50)

            startButton.backgroundColor = .systemBlue
            startButton.tintColor = .white

            startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
            
            view.addSubview(startButton)
            NSLayoutConstraint.activate([
                startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                startButton.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5),
                startButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
    }

    func hideStartButton() {
        startButton?.removeFromSuperview()
        startButton = nil
    }

    @objc func startButtonTapped() {
        UserDefaults.standard.set(true, forKey: "isAppAlreadyLaunchedOnce")
        UserDefaults.standard.synchronize()

        // 권한설정을 해주고 클로저를 통해 VC Present 해주기
        
        let mainTabController = MainTabController()
        mainTabController.modalPresentationStyle = .fullScreen
        present(mainTabController, animated: true, completion: nil)
        
        // completion handler
    }
}

