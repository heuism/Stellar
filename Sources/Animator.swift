//
//  Animator.swift
//  StellarDemo
//
//  Created by AugustRush on 5/17/16.
//  Copyright © 2016 August. All rights reserved.
//

import UIKit

public enum BehaviorType {
    case Gravity
    case Snap
    case Attachment
    case Push
    case collision
}

class Animator: NSObject, UIDynamicAnimatorDelegate {
    static let shared = Animator()
    private var activedAnimators: [UIDynamicAnimator] = Array()
    
    //MARK: public methods
    func createBehavior<T: Physical>(item: DynamicItem<T>, type: BehaviorType) -> UIDynamicBehavior {
        
        //behavior
        var behavior: UIDynamicBehavior!

        switch type {
        case .Gravity:
            let gravity = UIGravityBehavior()
            gravity.gravityDirection = CGVectorMake(item.toP.x - item.fromP.x, item.toP.y - item.fromP.y)
            gravity.magnitude = 10
            gravity.addItem(item)
            behavior = gravity
        case .Snap:
            let snap = UISnapBehavior(item: item,snapToPoint: item.toP)
            snap.damping = 0.5
            behavior = snap
        case .Attachment:
            let attachment = UIAttachmentBehavior(item: item,attachedToAnchor: item.toP)
            attachment.length = 0.0
            attachment.damping = 0.5
            attachment.frequency = 1
            behavior = attachment
        case .Push:
            let push = UIPushBehavior(items: [item], mode: .Instantaneous)
            push.pushDirection = CGVectorMake(item.toP.x - item.fromP.x, item.toP.y - item.fromP.y)
            push.magnitude = 1.0
            behavior = push
        case .collision: 
            let collision = UICollisionBehavior()
            collision.addItem(item)
            behavior = collision
        }
        
        return behavior
    }
    
    func addBehavior(b: UIDynamicBehavior) {
        let animator = UIDynamicAnimator()
        animator.delegate = self
        animator.addBehavior(b)
        activedAnimators.append(animator)
    }
    
    //MARK: UIDynamicAnimatorDelegate methods
    
    func dynamicAnimatorDidPause(animator: UIDynamicAnimator) {
        print("dynamic paused")
        let index = activedAnimators.indexOf(animator)
        activedAnimators.removeAtIndex(index!)
    }
    
    func dynamicAnimatorWillResume(animator: UIDynamicAnimator) {
        print("dynamic resume")
    }
}