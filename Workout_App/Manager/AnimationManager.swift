//
//  AnimationManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.09.22.
//

import UIKit

enum AnimationKeys: String {
    case shake = "shake"
    case position = "position"
    case positionX = "position.x"
    case transform = "transform"
    case rotationZ = "transform.rotation.z"
    case name = "animationName"
    
}

final class AnimationManager: NSObject, CAAnimationDelegate {
    
    private let animation = CAKeyframeAnimation()
    private let bezierPath = UIBezierPath()
    
    func shakeAnimation(ofView view: UIView) {
        animation.keyPath = AnimationKeys.positionX.rawValue
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.2
        animation.isAdditive = true
        view.layer.add(animation, forKey: AnimationKeys.shake.rawValue)
    }
    
    func movingAnimation(fromView: UIView, toView: UIView, completion: @escaping () -> ()) {
        
        CATransaction.begin()
           CATransaction.setCompletionBlock({
               completion()
           })
        
        bezierPath.move(to: fromView.center)
        bezierPath.addLine(to: toView.center)
        
        //move
        let moveAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.position.rawValue)
        moveAnimation.path = bezierPath.cgPath
        moveAnimation.isRemovedOnCompletion = true
        //scale
        let scaleAnimation = CABasicAnimation(keyPath: AnimationKeys.transform.rawValue)
        scaleAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        scaleAnimation.toValue = NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0))
        scaleAnimation.isRemovedOnCompletion = true
        //rotate
        let rotationAnimation = CABasicAnimation(keyPath: AnimationKeys.rotationZ.rawValue)
        rotationAnimation.toValue = NSNumber(value: -CGFloat.pi * 99 / 100)
        rotationAnimation.isCumulative = true
        rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
        rotationAnimation.isRemovedOnCompletion = true
        
        let animGroup = CAAnimationGroup()
        animGroup.delegate = self
        animGroup.setValue("curvedAnim", forKey: AnimationKeys.name.rawValue)
        animGroup.animations = [moveAnimation, scaleAnimation, rotationAnimation]
        animGroup.duration = 0.5
        fromView.layer.add(animGroup, forKey: "curvedAnim")
        CATransaction.commit()
    }
}
