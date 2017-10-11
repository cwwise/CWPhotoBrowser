//
//  PhotoBrowserScaleAnimator.swift
//  CWPhotoBrowserDemo
//
//  Created by chenwei on 2017/9/3.
//  Copyright © 2017年 cwwise. All rights reserved.
//

import UIKit

protocol PhotoBrowserScaleAnimatorDelegate : NSObjectProtocol {

    func presentAnimator(at index : Int) -> (imageView: UIImageView, startRect: CGRect, endRect: CGRect)

    func dismissAnimator(at index : Int) -> (imageView: UIImageView, startRect: CGRect, endRect: CGRect)
}

class PhotoBrowserScaleAnimator: NSObject {

    var isPresented : Bool = false

    var index: Int?
    
    var delegate: PhotoBrowserScaleAnimatorDelegate?
    
}


extension PhotoBrowserScaleAnimator : UIViewControllerTransitioningDelegate {

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresented = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? { 
        isPresented = false
        return self
    }
    
}

extension PhotoBrowserScaleAnimator : UIViewControllerAnimatedTransitioning {
    
    // 动画时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        isPresented ? presentAnimate(transitionContext) : dismissAnimate(transitionContext)
    }
    
    /// 弹出动画的封装
    func presentAnimate(_ transitionContext: UIViewControllerContextTransitioning) {

        guard let presentedView = transitionContext.view(forKey: .to) else {
            return
        }
        let containerView = transitionContext.containerView
        guard let delegate = delegate, let index = index else {
            containerView.addSubview(presentedView)
            transitionContext.completeTransition(true)
            return
        }
        
        let (startView, startFrame, endFrame) = delegate.presentAnimator(at: index)

        startView.frame = startFrame
        containerView.addSubview(startView)
        
        // 3.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            startView.alpha = 1.0
            startView.frame = endFrame
        }) { (_) in
            startView.removeFromSuperview()
            containerView.addSubview(presentedView)
            transitionContext.completeTransition(true)
        }
        
    }
    
    /// 消失动画的封装
    func dismissAnimate(_ transitionContext: UIViewControllerContextTransitioning) {
                
        guard let delegate = delegate, let index = index else {
            transitionContext.completeTransition(true)
            return
        }
        let presentedView = transitionContext.view(forKey: .from)
        presentedView?.isHidden = true
        let containerView = transitionContext.containerView
        
        let (dismissView, startFrame, endFrame) = delegate.dismissAnimator(at: index)
        dismissView.frame = startFrame
        containerView.addSubview(dismissView)
        // 执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { 
            dismissView.frame = endFrame
        }) { (_) in
            dismissView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
 

}
