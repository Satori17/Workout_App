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
    func displayRemoveWorkoutAlert(withMessage text: String)
    func didFailDisplayRemoveWorkoutAlert(withError message: StorageManagerError)
    func displayMissedWorkouts(viewModel: HomeModel.getMissedWorkouts.ViewModel)
    func didFailDisplayMissedWorkouts(withError message: StorageManagerError)
    func didFailDisplayToggleMissedWorkout(withError message: StorageManagerError)
}

final class HomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var homeSegmentControl: UISegmentedControl!
    @IBOutlet weak var savedWorkoutsTableView: UITableView!
    
    //MARK: - Clean Components
    var interactor: HomeBusinessLogic?
    var router: (HomeRoutingLogic & HomeDataPassing)?
    
    //MARK: - Notification Manager
    private let notificationManager = NotificationManager()
    
    //MARK: - Saved Workouts Data
    private var savedWorkouts = [[CoreWorkoutViewModel]]()
    private var weekDays = [WeekDayModel]()
    
    //MARK: - Missed Workouts Data
    private var missedWorkouts = [[CoreWorkoutViewModel]]()
    private var missedWeekDays = [WeekDayModel]()
    
    //MARK: - Object Lifecycle
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        HomeConfigurator.configure(vc: self)
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        checkUserPermission()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedWorkoutsRequest()
    }
    
    //MARK: - IBAction
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            savedWorkoutsRequest()
        case 1:
            missedWorkoutsRequest()
        default:
            break
        }
        savedWorkoutsTableView.reloadData()
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        savedWorkoutsTableView.registerNib(class: HomeWorkoutCell.self)
    }
    
    private func checkUserPermission() {
        notificationManager.checkUserPermission { granted in
            if !granted {
                self.notificationManager.deniedNotificationAlert(onVC: self)
            }
        }
    }
    
    private func setupSavedWorkouts(data: [[CoreWorkoutViewModel]], weekDays: [WeekDayModel]) {
        self.savedWorkouts = data
        self.weekDays = weekDays
        savedWorkoutsTableView.reloadData()
    }
    
    private func setupMissedWorkouts(data: [[CoreWorkoutViewModel]], weekDays: [WeekDayModel]) {
        self.missedWorkouts = data
        self.missedWeekDays = weekDays
        savedWorkoutsTableView.reloadData()
    }
    
    //MARK: - Request Methods
    private func savedWorkoutsRequest() {
        interactor?.getSavedWorkouts(request: HomeModel.GetSavedWorkouts.Request())
    }
    
    private func missedWorkoutsRequest() {
        interactor?.getMissedWorkouts(request: HomeModel.getMissedWorkouts.Request())
    }
}

//MARK: - HeaderView Delegate protocol
extension HomeViewController: notificationReceivedProtocol {
    
    func dismissCheckMark(cell: HomeWorkoutCell) {
        if let indexPath = savedWorkoutsTableView.indexPath(for: cell) {
            let currentSavedWorkout = homeSegmentControl.selectedSegmentIndex == 0 ? savedWorkouts[indexPath.section][indexPath.row] : missedWorkouts[indexPath.section][indexPath.row]
            interactor?.toggleMissedWorkout(false, weekDay: currentSavedWorkout.weekDay.name, id: currentSavedWorkout.id)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                self?.homeSegmentControl.selectedSegmentIndex == 0 ? self?.savedWorkoutsRequest() : self?.missedWorkoutsRequest()
            }
        }
    }
    
    func appearMissedWorkouts(cell: HomeWorkoutCell, weekDay: String) {
        if let indexPath = savedWorkoutsTableView.indexPath(for: cell) {
            let currentSavedWorkout = savedWorkouts[indexPath.section][indexPath.row]
            if currentSavedWorkout.weekDay.name == weekDay {
                interactor?.toggleMissedWorkout(true, weekDay: currentSavedWorkout.weekDay.name, id: currentSavedWorkout.id)
                DispatchQueue.main.async { [weak self] in
                    self?.savedWorkoutsRequest()
                }
            }
        }
    }
}

//MARK: - Cell Delegate protocol
extension HomeViewController: updateHeaderDataProtocol {
    
    func getScheduledTime() {
        savedWorkoutsRequest()
    }
}

//MARK: - Display Logic protocol
extension HomeViewController: HomeDisplayLogic {
    
    func displaySavedWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel) {
        setupSavedWorkouts(data: viewModel.displayedCoreWorkouts, weekDays: viewModel.weekDays)
    }
    
    func didFailDisplaySavedWorkouts(withError message: StorageManagerError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
    
    func displaySavedWorkoutDetails(viewModel: HomeModel.ShowSavedWorkoutDetails.ViewModel) {
        router?.routeToWorkoutDetails()
    }
    
    func displayRemoveWorkoutAlert(withMessage text: String) {
        router?.routeToShowAlert(withTitle: text, success: true)
    }
    
    func didFailDisplayRemoveWorkoutAlert(withError message: StorageManagerError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
    
    func displayMissedWorkouts(viewModel: HomeModel.getMissedWorkouts.ViewModel) {
        setupMissedWorkouts(data: viewModel.displayedMissedWorkouts, weekDays: viewModel.missedWorkoutWeekDays)
    }
    
    func didFailDisplayMissedWorkouts(withError message: StorageManagerError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
    
    func didFailDisplayToggleMissedWorkout(withError message: StorageManagerError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
}

//MARK: - TableView Delegate & DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        homeSegmentControl.selectedSegmentIndex == 0 ? weekDays.count : missedWeekDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeSegmentControl.selectedSegmentIndex == 0 ? savedWorkouts[section].count : missedWorkouts[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HomeWorkoutCell
        let currentWorkout = homeSegmentControl.selectedSegmentIndex == 0 ? savedWorkouts[indexPath.section][indexPath.row] : missedWorkouts[indexPath.section][indexPath.row]
        cell.configure(with: currentWorkout)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentWorkout = homeSegmentControl.selectedSegmentIndex == 0 ? savedWorkouts[indexPath.section][indexPath.row] : missedWorkouts[indexPath.section][indexPath.row]
        let request = HomeModel.ShowSavedWorkoutDetails.Request(savedWorkout: currentWorkout)
        interactor?.getSavedWorkoutDetails(request: request)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = WeekDayHeaderView()
        view.configure(weekDay: homeSegmentControl.selectedSegmentIndex == 0 ? weekDays[section] : missedWeekDays[section])
        view.workoutCategories = savedWorkouts[section].map({$0.category.name})
        view.delegate = self
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        homeSegmentControl.selectedSegmentIndex == 0 ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, homeSegmentControl.selectedSegmentIndex == 0 {
            let currentWorkout = savedWorkouts[indexPath.section][indexPath.row]
            interactor?.removeWorkout(withId: currentWorkout.id)
            self.savedWorkouts[indexPath.section].remove(at: indexPath.row)
            if savedWorkouts[indexPath.section].isEmpty {
                savedWorkouts.remove(at: indexPath.section)
                weekDays.remove(at: indexPath.section)
            }
            self.savedWorkoutsTableView.reloadData()
        }
    }
}
