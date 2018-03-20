//
//  TabBarController.swift
//  ARKitCarGeolocation
//
//  Created by Saransh Mittal on 18/03/18.
//  Copyright © 2018 Esteban Herrera. All rights reserved.
//

import UIKit

class ScrollingTabBarControllerDelegate: NSObject, UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return ScrollingTransitionAnimator(tabBarController: tabBarController, lastIndex: tabBarController.selectedIndex)
    }
}

class ScrollingTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    weak var transitionContext: UIViewControllerContextTransitioning?
    var tabBarController: UITabBarController!
    var lastIndex = 0
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    init(tabBarController: UITabBarController, lastIndex: Int) {
        self.tabBarController = tabBarController
        self.lastIndex = lastIndex
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        containerView.addSubview(toViewController!.view)
        var viewWidth = toViewController!.view.bounds.width
        if tabBarController.selectedIndex < lastIndex {
            viewWidth = -viewWidth
        }
        toViewController!.view.transform = CGAffineTransform(translationX: viewWidth, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: (self.transitionContext)), delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 2.5, options: .overrideInheritedOptions, animations: {
            toViewController!.view.transform = CGAffineTransform.identity
            fromViewController!.view.transform = CGAffineTransform(translationX: -viewWidth, y: 0)
        }, completion: { _ in
            self.transitionContext?.completeTransition(!self.transitionContext!.transitionWasCancelled)
            fromViewController!.view.transform = CGAffineTransform.identity
        })
    }
}

class TabBarController: UITabBarController {

    let del = ScrollingTabBarControllerDelegate()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = del
//        if Data.isLogged == true{
//            network.loadData()
//        } else {
//            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
//                self.present(viewController, animated: true, completion: nil)
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
