//
//  HamburgerViewController.swift
//  Youtube
//
//  Created by Justin Peng on 2/24/16.
//  Copyright © 2016 Justin Peng. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var feedView: UIView!
    @IBOutlet var contentView: UIView!
    
    var menuViewController: UIViewController!
    var feedViewController: UIViewController!
    
    var feedViewOriginalCenter: CGPoint!
    
    var feedViewPanGesture: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        feedViewOriginalCenter = feedView.center
        print(feedViewOriginalCenter)
        
        //Set up Menu View Controller
        menuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController")
        addChildViewController(menuViewController)
        menuView.addSubview(menuViewController.view)
        menuViewController.view.frame = menuView.bounds
        menuViewController.didMoveToParentViewController(self)
        
        //Set up Feed View Controller
        
        feedViewController = storyboard.instantiateViewControllerWithIdentifier("FeedViewController")
        addChildViewController(feedViewController)
        feedView.addSubview(feedViewController.view)
        feedViewController.view.frame = feedView.bounds
        feedViewController.didMoveToParentViewController(self)
        
        feedViewPanGesture = UIPanGestureRecognizer(target: self, action: "didPanFeed:")
        feedView.addGestureRecognizer(feedViewPanGesture)
        feedViewPanGesture.enabled = true

        // Do any additional setup after loading the view.
    }
    
    func didPanFeed(sender: UIPanGestureRecognizer) {
        var translation_x = sender.translationInView(contentView).x
        var location_x = sender.locationInView(contentView).x
        var velocity_x = sender.velocityInView(contentView).x
        let initialMenuTransform = CGAffineTransformMakeScale(0.9, 0.9)
        var menuScale = convertValue(location_x, r1Min: 0, r1Max: 290, r2Min: 0.9, r2Max: 1.0)
        
        if sender.state == UIGestureRecognizerState.Began {
            menuView.transform = initialMenuTransform
        } else if sender.state == UIGestureRecognizerState.Changed {
            print("translation:" + String(translation_x))
            print("location:" + String(location_x))
            
            if translation_x > 0 {
                feedView.center.x = feedViewOriginalCenter.x + translation_x

            }
            else if translation_x < 0 && feedView.center.x > feedViewOriginalCenter.x {
                feedView.center.x = feedViewOriginalCenter.x + 290 + translation_x
                
            }
            menuView.transform = CGAffineTransformMakeScale(menuScale, menuScale)
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if velocity_x > 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedView.center = CGPoint(x: self.feedViewOriginalCenter.x + 290, y: self.feedViewOriginalCenter.y)
                    self.menuView.transform = CGAffineTransformMakeScale(1, 1)
                })
            } else if velocity_x < 0 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedView.center = CGPoint(x: self.feedViewOriginalCenter.x, y: self.feedViewOriginalCenter.y)
                    self.menuView.transform = CGAffineTransformMakeScale(0.9, 0.9)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
