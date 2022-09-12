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
    @IBOutlet weak var savedWorkoutsTableView: UITableView!
    
    //MARK: - Properties
    
    //clean components
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    //notification manager
    private let notificationManager = NotificationManager()
    //workouts data
    private var savedWorkouts = [[CoreWorkoutViewModel]]()
    //week days data
    private var weekDays = [String]()
    
    //MARK: - Object Lifecycle
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        HomeConfigurator.configure(vc: self)
    }
    
    // MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedWorkoutsTableView.registerNib(class: HomeWorkoutCell.self)
        notificationManager.checkUserPermission { granted in
            if granted {
                print("Granted")
            } else {
                print("Denied")
            }
        }
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
    
    private func setupSavedWorkouts(data: [[CoreWorkoutViewModel]], weekDays: [String]) {
        self.savedWorkouts = data
        self.weekDays = weekDays
        savedWorkoutsTableView.reloadData()
    }
}

//MARK: - Display Logic protocol

extension HomeViewController: HomeDisplayLogic {
    
    func displaySavedWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel) {
        setupSavedWorkouts(data: viewModel.displayedCoreWorkouts, weekDays: viewModel.weekDays)
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
        weekDays.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWorkouts[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HomeWorkoutCell
        let currentWorkout = savedWorkouts[indexPath.section][indexPath.row]
        cell.configure(with: currentWorkout)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentWorkout = savedWorkouts[indexPath.section][indexPath.row]
        let request = HomeModel.ShowSavedWorkoutDetails.Request(savedWorkout: currentWorkout)
        interactor?.getSavedWorkoutDetails(request: request)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = WeekDayHeaderView()
        view.weekDayLabel.text = weekDays[section]
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentWorkout = savedWorkouts[indexPath.section][indexPath.row]
            interactor?.removeWorkout(withId: Int(currentWorkout.id))
            self.savedWorkouts[indexPath.section].remove(at: indexPath.row)
            if savedWorkouts[indexPath.section].isEmpty {
                savedWorkouts.remove(at: indexPath.section)
                weekDays.remove(at: indexPath.section)
            }
            self.savedWorkoutsTableView.reloadData()
        }
    }
    
}
