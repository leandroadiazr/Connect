//
//  CustomTransition.swift
//  Content
//
//  Created by Leandro Diaz on 1/20/21.
//
import UIKit

//MARK:- CUSTOM TRANSITION FOR VIEW CONTROLLERS
class CustomTransition:NSObject, UIViewControllerAnimatedTransitioning {
    internal var isPresenting = false
   
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
   
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        var toView:UIView?
        var finalFrame:CGRect = .zero
       
        if isPresenting {
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            let cView = transitionContext.containerView
            if cView == transitionContext.containerView,
                let tView = toView {
                    let cFrame = cView.frame
                tView.frame = CGRect(x: cFrame.width, y: cFrame.minY, width: cFrame.width, height: cFrame.height)
                    cView.addSubview(tView)
                    finalFrame = cFrame
            }
        }
        else {
            toView = transitionContext.view(forKey: UITransitionContextViewKey.from)
            if let tView = toView {
                finalFrame = CGRect(x: tView.frame.width, y: tView.frame.minY, width: tView.frame.width, height: tView.frame.height)
            }
        }
       
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: { () -> Void in
            toView?.frame = finalFrame
            }) { (complete) -> Void in
                transitionContext.completeTransition(true)
        }
    }
}
