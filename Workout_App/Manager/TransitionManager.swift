//
//  TransitionManager.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.09.22.
//

import UIKit

final class TransitionManager: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    private var operation = UINavigationController.Operation.push
    
    init(duration: TimeInterval) {
        self.duration = duration
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromViewController = transitionContext.viewController(forKey: .from),
            let toViewController = transitionContext.viewController(forKey: .to)
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        animateTransition(from: fromViewController, to: toViewController, with: transitionContext)
    }
}

// MARK: - UINavigationControllerDelegate

extension TransitionManager: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        self.operation = operation
        
        if operation == .push {
            return self
        }
        
        return nil
    }
}


// MARK: - Animations

private extension TransitionManager {
    func animateTransition(from fromViewController: UIViewController, to toViewController: UIViewController, with context: UIViewControllerContextTransitioning) {
        switch operation {
        case .push:
            guard
                let albumsViewController = fromViewController as? WorkoutsViewController,
                let detailsViewController = toViewController as? WorkoutDetailViewController
            else { return }
            
            presentViewController(detailsViewController, from: albumsViewController, with: context)
            
        case .pop:
            guard
                let detailsViewController = fromViewController as? WorkoutDetailViewController,
                let albumsViewController = toViewController as? WorkoutsViewController
            else { return }
            
            dismissViewController(detailsViewController, to: albumsViewController)
            
        default:
            break
        }
    }
    
    func presentViewController(_ toViewController: WorkoutDetailViewController, from fromViewController: WorkoutsViewController, with context: UIViewControllerContextTransitioning) {
        
        guard
            let albumCell = fromViewController.currentCell,
            let albumCoverImageView = fromViewController.currentCell?.workoutImageView,
            //let albumDetailHeaderView = toViewController.headerView
                let workoutDetailsImageView = toViewController.contentView
        else { return }
        
        toViewController.view.layoutIfNeeded()
        
        let gradientMask = CAGradientLayer()
        let containerView = context.containerView
        
        let snapshotContentView = UIView()
        snapshotContentView.backgroundColor = .white
        snapshotContentView.withAppDesign(layer: gradientMask, curvedCorners: false)
        snapshotContentView.frame = containerView.convert(albumCell.contentView.frame, from: albumCell)
        snapshotContentView.layer.cornerRadius = albumCell.contentView.layer.cornerRadius
        
        let snapshotAlbumCoverImageView = UIImageView()
        snapshotAlbumCoverImageView.clipsToBounds = true
        snapshotAlbumCoverImageView.contentMode = albumCoverImageView.contentMode
        snapshotAlbumCoverImageView.image = albumCoverImageView.image
        snapshotAlbumCoverImageView.layer.cornerRadius = albumCoverImageView.layer.cornerRadius
        snapshotAlbumCoverImageView.frame = containerView.convert(albumCoverImageView.frame, from: albumCell)
        
        
        containerView.addSubview(toViewController.view)
        containerView.addSubview(snapshotContentView)
        containerView.addSubview(snapshotAlbumCoverImageView)
        
        toViewController.view.isHidden = true
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            snapshotContentView.frame = containerView.convert(toViewController.view.frame, from: toViewController.view)
            //snapshotAlbumCoverImageView.frame = containerView.convert(albumDetailHeaderView.albumCoverImageView.frame, from: albumDetailHeaderView)
            snapshotAlbumCoverImageView.frame = containerView.convert(workoutDetailsImageView.mainImageView.frame, from: workoutDetailsImageView)
            snapshotAlbumCoverImageView.layer.cornerRadius = 0
        }

        animator.addCompletion { position in
            toViewController.view.isHidden = false
            snapshotAlbumCoverImageView.removeFromSuperview()
            snapshotContentView.removeFromSuperview()
            context.completeTransition(position == .end)
        }

        animator.startAnimation()
    }
    
    func dismissViewController(_ fromViewController: WorkoutDetailViewController, to toViewController: WorkoutsViewController) {
        
    }
}
