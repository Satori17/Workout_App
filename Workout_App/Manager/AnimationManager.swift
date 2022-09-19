//
//  AnimationManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.09.22.
//

import UIKit

final class AnimationManager: NSObject, CAAnimationDelegate {
    
    //MARK: - Properties
    private let animation = CAKeyframeAnimation()
    private let bezierPath = UIBezierPath()
    
    //MARK: - Animation Methods
    func shakeAnimation(ofView view: UIView) {
        animation.keyPath = AnimationKeys.positionX.rawValue
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.2
        animation.isAdditive = true
        view.layer.add(animation, forKey: AnimationKeys.shake.rawValue)
    }
    
    func movingAnimation(fromView: UIView, toView: UIView, isRotated: Bool, completion: @escaping () -> ()) {
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
        animGroup.setValue(AnimationKeys.curvedAnim.rawValue, forKey: AnimationKeys.name.rawValue)
        animGroup.animations = [moveAnimation, scaleAnimation]
        if isRotated {
            animGroup.animations?.append(rotationAnimation)
        }
        animGroup.duration = 0.5
        fromView.layer.add(animGroup, forKey: AnimationKeys.curvedAnim.rawValue)
        CATransaction.commit()
    }
    
    func zoomingAnimation(ofView view: UIView, withShake: Bool, completion: @escaping () -> ()) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if withShake {
                self?.shakeAnimation(ofView: view)
            }
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
        } completion: { _ in
            UIView.animate(withDuration: 0.3) {
                view.transform = CGAffineTransform.identity
            } completion: { _ in
                completion()
            }
        }
    }
    
    //MARK: - Helper Animation Methods
    func toggleAppearence(ofViews views: [UIView], actorView: UIView, completion: (() -> ())? = nil) {
        UIView.transition(with: actorView, duration: 0.3, options: .allowAnimatedContent) {
            views.forEach{ $0.alpha = $0.alpha == 1 ? 0 : 1 }
        } completion: { _ in
            completion?()
        }
    }
    
    func toggleAppearence(ofButtons buttons: [UIButton]) {
        UIView.animate(withDuration: 0.3) {
            buttons.forEach{
                $0.alpha = $0.alpha == 1 ? 0 : 1
                $0.isHidden = $0.alpha == 0
            }
        }
    }
    
    func checkIfButtonsAppeared(_ buttons: [UIButton]) -> Bool {
        var result = false
        buttons.forEach{
            result = $0.alpha == 1
        }
        
        return result
    }
    
    func animateTransition(ofView view: UIView) {
        UIView.transition(
            with: view,
            duration: 0.5,
            options: .transitionFlipFromRight,
            animations: nil,
            completion: nil
        )
    }
}
