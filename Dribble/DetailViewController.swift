//
//  DetailViewController.swift
//  Dribble
//
//  Created by 王笛 on 16/7/3.
//  Copyright © 2016年 王笛iOS.Inc. All rights reserved.
//

import UIKit

enum didShow {
    case yes
    case no
}

class DetailViewController: UIViewController, UIScrollViewDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    var detailView: UIView!
    var detailImage = UIImageView()
    var detailLabel = UILabel()
    //var words = CLTypingLabel()
    var extra: UIView!
    //@IBOutlet weak var detailView: UIView!
    var image: UIImage!
    var label: UILabel!
    var picLayer: CAShapeLayer!
    var model: AnyObject!
    let offSet = CGPoint(x: 0, y: 600)
    let targetView = ViewController()
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.words.text = "> I Want To Attend WWDC 2017."
        //self.words.pauseTyping()
        //self.extra = words
        self.extra = UIView()
        self.detailView = UIView()
        self.detailView.frame = CGRect(x: 0, y: 700, width: self.view.frame.size.width, height: 800)
        self.detailView.addSubview(extra)
        self.detailImage.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.scrollView.addSubview(detailImage)
        self.detailLabel.text = self.label.text
        self.detailLabel.frame = CGRect(x: 50, y: 450, width: 200, height: 50)
        self.detailLabel.textColor = UIColor.whiteColor()
        self.scrollView.addSubview(detailLabel)
        self.detailLabel.font = UIFont(name: "STHeitiTC-Light", size: 35)
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
        self.detailView.userInteractionEnabled = true
        //self.drawRact()
        //WeatherInfo().parsingURL()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(DetailViewController.edgePanGesture(_:)))
        edgePan.edges = .Left
        self.view.addGestureRecognizer(edgePan)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.detailImage.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
        let progress = 300 - scrollView.contentOffset.y
        if scrollView.contentOffset.y > 0 {
            self.detailImage.alpha = progress / 300
        }
        if scrollView.contentOffset.y > 300 {
            self.detailImage.alpha = 0
        }else if scrollView.contentOffset.y < 300 {
            self.scrollView.addSubview(self.detailImage)
            self.scrollView.addSubview(self.detailLabel)
        }
        if scrollView.contentOffset.y > 430 {
            self.detailLabel.frame = CGRect(x: 50, y: scrollView.contentOffset.y + 20, width: 200, height: 50)
            //self.words.continueTyping()
            //self.scrollView.userInteractionEnabled = false
        }
    }
    /*
    func moveToOffSet() {
        self.scrollView.setContentOffset(offSet, animated: true)
    }
 */
    /*
    func drawRact() {
        
        self.picLayer = CAShapeLayer()
        self.picLayer.fillColor = UIColor.blackColor().CGColor
        self.detailImage.layer.mask = self.picLayer
        
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, 0))
        path.addLineToPoint(CGPointMake(self.detailImage.frame.size.width, 0))
        path.addLineToPoint(CGPointMake(self.detailImage.frame.size.width, self.detailImage.frame.size.height))
        path.addLineToPoint(CGPointMake(0, self.detailImage.frame.size.height - 100))
        self.picLayer.path = path.CGPath
    }
    */
    func edgePanGesture(edgePan: UIScreenEdgePanGestureRecognizer) {
        let progress = edgePan.translationInView(self.view).x / self.view.bounds.width
        
        if edgePan.state == UIGestureRecognizerState.Began {
        self.extra.removeFromSuperview()
        self.percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewControllerAnimated(true)
        } else if edgePan.state == UIGestureRecognizerState.Changed {
            self.percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if edgePan.state == UIGestureRecognizerState.Cancelled || edgePan.state == UIGestureRecognizerState.Ended {
            if progress > 0.5 {
                self.detailView.addSubview(extra)
                self.percentDrivenTransition?.finishInteractiveTransition()
            } else {
                self.detailView.addSubview(extra)
                self.percentDrivenTransition?.cancelInteractiveTransition()
            }
            self.percentDrivenTransition = nil
        }
    }
    
    
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.Pop {
            return CustomBackwardTransition()
        } else {
            return nil
        }
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController is CustomBackwardTransition {
            return self.percentDrivenTransition
        } else {
            return nil
        }
    }
    
}
