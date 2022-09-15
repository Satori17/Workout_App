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
    
    //MARK: - Clean Components
    var interactor: WorkoutsBusinessLogic?
    var router: (WorkoutsRoutingLogic & WorkoutsDataPassing)?
    
    //MARK: - Workouts Data
    private var workouts = [WorkoutViewModel]()
    
    //MARK: - Activity Indicator Manager
    let activityIndicator = ActivityIndicatorManager.shared
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        activityIndicator.startAnimating()
    }
    
    //MARK: - Methods
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = false
        activityIndicator.setupActivityIndicator(self)
        makeRequest()
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        workoutsCollectionView.registerNib(class: WorkoutCell.self)
        if let flowLayout = self.workoutsCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 10
            flowLayout.scrollDirection = .horizontal
        }
    }
    
    private func setupWorkouts(data: [WorkoutViewModel]) {
        self.workouts = data
        workoutsCollectionView.reloadData()
        activityIndicator.stopAnimating()
    }
    
    private func makeRequest() {
        interactor?.getWorkouts(request: WorkoutModel.GetWorkouts.Request())
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

//MARK: - Cell Delegate protocol

extension WorkoutsViewController: WorkoutDetailsDelegate {
    func getWorkoutDetails(cell: WorkoutCell) {
        if let indexPath = workoutsCollectionView.indexPath(for: cell) {
            let currentWorkout = workouts[indexPath.row]
            let request = WorkoutModel.ShowWorkoutDetails.Request(workout: currentWorkout, isAnimated: true)
            interactor?.showWorkoutDetails(request: request)
        }
    }
}

//MARK: - Display Logic protocol

extension WorkoutsViewController: WorkoutsDisplayLogic {
    
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
        return UIDevice.current.orientation.isLandscape ? CGSize(width: view.frame.width/4, height: view.frame.height/2.7) : CGSize(width: view.frame.width/2.6, height: view.frame.height/4)
    }
}
