//
//  HomeViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displaySavedWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel)
    func didFailDisplaySavedWorkouts(withError message: StorageManagerError)
    func displaySavedWorkoutDetails(viewModel: HomeModel.ShowSavedWorkoutDetails.ViewModel)
}

final class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var homeSegmentControl: UISegmentedControl!
    @IBOutlet weak var homeTableView: UITableView!
    
    //MARK: - Properties
    
    //clean components
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    //workouts data
    var savedWorkouts: [CoreWorkoutViewModel] = []
    
    //MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        HomeConfigurator.configure(vc: self)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeTableView.registerNib(class: HomeWorkoutCell.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        makeRequest()
    }
    
    //MARK: - IBAction
    
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        
    }
    
    
    //MARK: - Methods
    
    private func makeRequest() {
        interactor?.getSavedWorkouts(request: HomeModel.GetSavedWorkouts.Request())
    }
    
    private func setupSavedWorkouts(data: [CoreWorkoutViewModel]) {
        self.savedWorkouts = data
        homeTableView.reloadData()
    }
}

//MARK: - Display Logic protocol

extension HomeViewController: HomeDisplayLogic {
    
    func displaySavedWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel) {
        setupSavedWorkouts(data: viewModel.displayedCoreWorkouts)
    }
    
    func didFailDisplaySavedWorkouts(withError message: StorageManagerError) {
        //TODO: - FIX THIS with alerts
        print(message)
    }
    
    func displaySavedWorkoutDetails(viewModel: HomeModel.ShowSavedWorkoutDetails.ViewModel) {
        router?.routeToWorkoutDetails()
    }
    
}

//MARK: - TableView Delegate & DataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        savedWorkouts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HomeWorkoutCell
        let currentWorkout = savedWorkouts[indexPath.row]
        cell.configure(with: currentWorkout)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentWorkout = savedWorkouts[indexPath.row]
        let request = HomeModel.ShowSavedWorkoutDetails.Request(savedWorkout: currentWorkout)
        interactor?.getSavedWorkoutDetails(request: request)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = WeekDayHeaderView()
        view.weekDayLabel.text = "Monday"
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentWorkout = savedWorkouts[indexPath.row]
            interactor?.removeWorkout(withId: Int(currentWorkout.id))
            self.savedWorkouts.remove(at: indexPath.row)
            self.homeTableView.reloadData()
        }
    }
    
}
