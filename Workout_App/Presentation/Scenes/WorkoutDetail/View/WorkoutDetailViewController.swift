//
//  WorkoutDetailViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 08.08.22.
//

import UIKit

protocol WorkoutDetailDisplayLogic: AnyObject {
    func displayWorkoutDetails(viewModel: WorkoutDetailModel.GetWorkoutDetails.ViewModel)
    func didFailDisplayWorkoutDetails(withError message: String)
    func displayWorkoutLicense(viewModel: WorkoutDetailModel.GetLicense.ViewModel)
    func displaySaveAlert(viewModel: WorkoutDetailModel.ShowSaveAlert.ViewModel)
}

final class WorkoutDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: WorkoutDetailView!
    
    //MARK: - Clean Components
    var interactor: WorkoutDetailBusinessLogic?
    var router: (WorkoutDetailRoutingLogic & WorkoutDetailDataPassing)?
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMovieDetails()
    }
    
    //MARK: - Request Methods
    private func requestMovieDetails() {
        interactor?.showWorkoutDetails(request: WorkoutDetailModel.GetWorkoutDetails.Request())
    }
    
    //MARK: - Setup Methods
    private func setupContentView(withData data: Displayable, isSaved: Bool) {
        contentView.addWorkoutBtn.isHidden = isSaved
        contentView.configure(with: data)
        contentView.scrollView = self.scrollView
        contentView.licenseDelegate = self
        contentView.workoutSaverDelegate = self
    }
}

//MARK: - License Delegate protocol
extension WorkoutDetailViewController: licenseDetailsDelegate {
    
    func openLicenseDetails() {
        interactor?.showWorkoutLicense(request: WorkoutDetailModel.GetLicense.Request())
    }
}

//MARK: - Save Delegate protocol
extension WorkoutDetailViewController: SaveWorkoutDelegate {
    
    func saveWorkout() {
        interactor?.showSaveAlert(request: WorkoutDetailModel.ShowSaveAlert.Request())
    }
}

//MARK: - Display Logic protocol
extension WorkoutDetailViewController: WorkoutDetailDisplayLogic {
    
    func displayWorkoutDetails(viewModel: WorkoutDetailModel.GetWorkoutDetails.ViewModel) {
        setupContentView(withData: viewModel.workout, isSaved: viewModel.isSaved)
    }
    
    func didFailDisplayWorkoutDetails(withError message: String) {
        router?.routeToShowAlert(withTitle: message, success: false)
    }
    
    func displayWorkoutLicense(viewModel: WorkoutDetailModel.GetLicense.ViewModel) {
        router?.routeToWorkoutLicense()
    }
    
    func displaySaveAlert(viewModel: WorkoutDetailModel.ShowSaveAlert.ViewModel) {
        router?.routeToSaveAlert()
    }
}
