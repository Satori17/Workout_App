//
//  WorkoutsViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.08.22.
//

import UIKit

protocol WorkoutsDisplayLogic: AnyObject {
    func displayWorkouts(viewModel: WorkoutModel.GetWorkouts.ViewModel)
    func didFailDisplayWorkouts(withError message: FetchingError)
    func displayWorkoutDetails(viewModel: WorkoutModel.ShowWorkoutDetails.ViewModel)
    func displaySaveAlert(viewModel: WorkoutModel.ShowSaveAlert.ViewModel)
}

final class WorkoutsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var workoutsCollectionView: UICollectionView!
    
    //MARK: - Properties
    
    //clean components
    var interactor: WorkoutsBusinessLogic?
    var router: (WorkoutsRoutingLogic & WorkoutsDataPassing)?
    //workouts data
    private var workouts = [WorkoutViewModel]()
    var categoryId: Int?
    
    
    var currentCell: WorkoutCell?
    let transitionManager = TransitionManager(duration: 0.5)
    
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        ActivityIndicatorManager.shared.setupActivityIndicator(self)
        makeRequest()
        setupCollectionView()
    }
    
    //MARK: - Methods
    
    private func setupCollectionView() {
        //registering cell
        workoutsCollectionView.registerNib(class: WorkoutCell.self)
        //flow layout
        if let flowLayout = self.workoutsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    private func setupWorkouts(data: [WorkoutViewModel]) {
        self.workouts = data
        workoutsCollectionView.reloadData()
        ActivityIndicatorManager.shared.stopAnimating()
    }
    
    private func makeRequest() {
        guard let categoryId = categoryId else { return }
        let request = WorkoutModel.GetWorkouts.Request(categoryId: categoryId)
        interactor?.getWorkouts(request: request)
    }
    
    
    private func makeContextMenu(for workout: WorkoutViewModel) -> UIMenu {
        let addWorkout = UIAction(title: ContextMenuTitle.addWorkout, image: UIImage(systemName: ContextMenuImage.addIcon)) { [weak self] action in
            let request = WorkoutModel.ShowSaveAlert.Request(workout: workout)
            self?.interactor?.showSaveAlert(request: request)
        }
        
        let goToWorkoutDetails = UIAction(title: ContextMenuTitle.seeMore, image: UIImage(systemName: ContextMenuImage.infoIcon)) { [weak self] action in
            let request = WorkoutModel.ShowWorkoutDetails.Request(workout: workout, isAnimated: false)
            self?.interactor?.showWorkoutDetails(request: request)
        }
        return UIMenu(title: "", children: [addWorkout, goToWorkoutDetails])
    }
    
}

//MARK: - Display Logic & delegate protocol

extension WorkoutsViewController: WorkoutsDisplayLogic, WorkoutDetailsDelegate {    
    
    func getWorkoutDetails(cell: WorkoutCell) {
        if let indexPath = workoutsCollectionView.indexPath(for: cell) {
            let currentWorkout = workouts[indexPath.row]
            let request = WorkoutModel.ShowWorkoutDetails.Request(workout: currentWorkout, isAnimated: true)
            interactor?.showWorkoutDetails(request: request)
            currentCell = cell
        }
    }
    
    func displayWorkouts(viewModel: WorkoutModel.GetWorkouts.ViewModel) {
        setupWorkouts(data: viewModel.displayedWorkouts)
    }
    
    func didFailDisplayWorkouts(withError message: FetchingError) {
        //TODO: - FIX THIS with alerts
        print(message.rawValue)
    }
    
    func displayWorkoutDetails(viewModel: WorkoutModel.ShowWorkoutDetails.ViewModel) {
        router?.routeToWorkoutDetails()
    }
    
    func displaySaveAlert(viewModel: WorkoutModel.ShowSaveAlert.ViewModel) {
        router?.routeToSaveAlert()
    }
    
}

//MARK: - CollectionView Delegate, DataSource & FlowLayout

extension WorkoutsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        workouts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as WorkoutCell
        let currentWorkout = workouts[indexPath.row]
        cell.configure(with: currentWorkout)
        //TODO: - FIX THIS check why i did write this here
        cell.clipsToBounds = true
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let currentWorkout = workouts[indexPath.row]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: { [weak self] in
            return self?.router?.instantiateDetailsVC(withWorkout: currentWorkout)
        }, actionProvider: { action in
            return self.makeContextMenu(for: currentWorkout)
        })        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape {
            return CGSize(width: view.frame.width/4, height: view.frame.height/2.7)
        }
        return CGSize(width: view.frame.width/2.6, height: view.frame.height/4)
    }
    
}
