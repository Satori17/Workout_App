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
    func didFailDisplayWorkoutLicense(withError message: String)
    func displaySaveAlert(viewModel: WorkoutDetailModel.ShowSaveAlert.ViewModel)
}

final class WorkoutDetailViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: WorkoutDetailView!
    
    //MARK: - Properties
    
    //clean components
    var interactor: WorkoutDetailBusinessLogic?
    var router: (WorkoutDetailRoutingLogic & WorkoutDetailDataPassing)?
    var isSaved = false
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMovieDetails()
    }
    
    //MARK: - Methods
    
    private func requestMovieDetails() {
        interactor?.showWorkoutDetails(request: WorkoutDetailModel.GetWorkoutDetails.Request())
    }
    
}

//MARK: - Delegate protocol

extension WorkoutDetailViewController : licenseDetailsDelegate, SaveWorkoutDelegate {
    
    func saveWorkout() {
        interactor?.showSaveAlert(request: WorkoutDetailModel.ShowSaveAlert.Request())
    }
    
    func openLicenseDetails() {
        interactor?.showWorkoutLicense(request: WorkoutDetailModel.GetLicense.Request())
    }
    
}

//MARK: - Display Logic protocol

extension WorkoutDetailViewController: WorkoutDetailDisplayLogic {
    
    //workout details
    func displayWorkoutDetails(viewModel: WorkoutDetailModel.GetWorkoutDetails.ViewModel) {
        contentView.addWorkoutBtn.isHidden = isSaved
        contentView.configure(with: viewModel.workout)
        contentView.scrollView = self.scrollView
        contentView.licenseDelegate = self
        contentView.workoutSaverDelegate = self
    }
    
    func didFailDisplayWorkoutDetails(withError message: String) {
        //TODO: - FIX THIS with alerts
        print(message)
    }
    
    func displayWorkoutLicense(viewModel: WorkoutDetailModel.GetLicense.ViewModel) {
        router?.routeToWorkoutLicense()
    }
    
    func didFailDisplayWorkoutLicense(withError message: String) {
        //TODO: - FIX THIS with alerts
        print(message)
    }
    
    func displaySaveAlert(viewModel: WorkoutDetailModel.ShowSaveAlert.ViewModel) {
        router?.routeToSaveAlert()
    }
    
}