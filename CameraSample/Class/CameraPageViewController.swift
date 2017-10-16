//
//  CameraPageViewController.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/10.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class CameraPageViewController: UIViewController {

    fileprivate var pagerVC: PageViewController!
    fileprivate var pageList = [UIViewController]()
    fileprivate var slideMargin: CGFloat = 0.0
    
    @IBOutlet weak var contaireView: UIView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet weak var bottomStackView: UIStackView!
    
    @IBAction func actionCamera(_ sender: UIButton) {
        guard !sender.isSelected else {
            return
        }
        changeButton(direction: .reverse)
    }
    
    @IBAction func actionLibrary(_ sender: UIButton) {
        guard !sender.isSelected else {
            return
        }
        changeButton(direction: .forward)
    }

    private func changeButton(direction: UIPageViewControllerNavigationDirection) {
        switch direction {
        case .forward:
            pagerVC.setViewControllers([pageList[1]], direction: .forward, animated: true, completion: nil)
            sliderView.frame.origin.x = slideMargin
            libraryBtn.isSelected = true
            cameraBtn.isSelected = false
            UIView.animate(withDuration: 0.4,
                           animations: {
                            self.sliderView.frame.origin.x = self.slideMargin + self.view.frame.size.width / 2
            }
            )
            return
        case .reverse:
            pagerVC.setViewControllers([pageList[0]], direction: .reverse, animated: true, completion: nil)
            sliderView.frame.origin.x = self.view.frame.size.width / 2
            libraryBtn.isSelected = false
            cameraBtn.isSelected = true
            UIView.animate(withDuration: 0.4,
                           animations: {
                            self.sliderView.frame.origin.x -= self.sliderView.frame.size.width
            }
            )
            return
        default:
            return
        }
    }    

// MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pagerVC = self.childViewControllers[0] as! PageViewController
        pagerVC.dataSource = self
        let cameraVC = storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        cameraVC.delegate = self
        pageList.append(cameraVC)
        let photoVC = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
        photoVC.delegate = self
        photoVC.setNavigationItem(navigationItem: self.navigationItem)
        pageList.append(photoVC)
        pagerVC.setViewControllers([pageList[0]], direction: .forward, animated: true, completion: nil)
        sliderView.translatesAutoresizingMaskIntoConstraints = false
        sliderView.frame.origin.x = 0
        sliderView.frame.size.height = 2
        cameraBtn.tintColor = UIColor.clear
        cameraBtn.setTitleColor(UIColor.darkGray, for: .selected)
        cameraBtn.setTitleColor(UIColor.gray, for: .normal)
        libraryBtn.tintColor = UIColor.clear
        libraryBtn.setTitleColor(UIColor.darkGray, for: .selected)
        libraryBtn.setTitleColor(UIColor.gray, for: .normal)
        cameraBtn.isSelected = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sliderView.frame.size.width = cameraBtn.frame.size.width*0.95
        slideMargin = (self.view.frame.size.width/2 - sliderView.frame.size.width) / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func updateViewConstraints() {
        bottomStackView.heightAnchor.constraint(equalToConstant: kBottomBarHeight).isActive = true

        super.updateViewConstraints()
    }
}

// MARK: PageViewControllerDelegate
extension CameraPageViewController: PageViewControllerDelegate {
    
    func transitionViewController(viewController: UIViewController) -> Bool {
        if pageList.contains(viewController) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "EditImageViewController") as! EditImageViewController
            self.navigationController?.pushViewController(vc, animated: true)
            return true
        }
        return false
    }
}

// MARK: UIPageViewControllerDataSource
extension CameraPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = pageList.index(of: viewController), index > 0 else {
            return nil
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.actionCamera(UIButton.init())
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {

        guard let index = pageList.index(of: viewController), index < pageList.count - 1 else {
            return nil
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.actionLibrary(UIButton.init())
        }
        return nil
    }
}

