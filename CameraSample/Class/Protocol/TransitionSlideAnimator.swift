//
//  TransitionSlideAnimator.swift
//  CameraSample
//
//  Created by TakuyaMano on 2017/10/06.
//  Copyright © 2017年 TakuyaMano. All rights reserved.
//

import UIKit

class TransitionSlideAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let kMovedDistance: CGFloat = 70.0
    let kDuration = 0.3
    var presenting = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return kDuration
    }
    
    // This method can only  be a nop if the transition is interactive and not a percentDriven interactive transition.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        if presenting {
            presentTransition(transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        } else {
            dismissTransition(transitionContext, toView: toVC!.view, fromView: fromVC!.view)
        }
    }

    func presentTransition(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, aboveSubview: fromView)
        toView.frame = toView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.05,
                       options: .curveEaseInOut,
                       animations: {
                            fromView.frame = fromView.frame.offsetBy(dx: -self.kMovedDistance, dy: 0.0)
                            fromView.alpha = 0.7
                            toView.frame = containerView.frame
                       }) { (finished) in
                            fromView.frame = fromView.frame.offsetBy(dx: self.kMovedDistance, dy: 0.0)
                            transitionContext.completeTransition(true)
                       }
    }
    
    func dismissTransition(_ transitionContext: UIViewControllerContextTransitioning, toView: UIView, fromView: UIView) {

        let containerView = transitionContext.containerView
        containerView.insertSubview(toView, belowSubview: fromView) // fromViewの下にtoView
        toView.frame = toView.frame.offsetBy(dx: -kMovedDistance, dy: 0)
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.05,
                       options: .curveEaseInOut,
                       animations: {
                            fromView.frame = fromView.frame.offsetBy(dx: containerView.frame.size.width, dy: 0.0)
                            toView.frame = toView.frame.offsetBy(dx: self.kMovedDistance, dy: 0.0)
                            toView.alpha = 1.0
                        }) { (finished) in
                            transitionContext.completeTransition(true)
                        }
    }
}

extension TransitionSlideAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        self.presenting = true
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.presenting = false
        return self
    }
}
