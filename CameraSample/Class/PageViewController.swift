//
//  PageViewController.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/10.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

protocol PageViewControllerDelegate {
    
    func transitionViewController(viewController: UIViewController) -> Bool
}

class PageViewController: UIPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

