//
//  HomeViewController.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 04.09.22.
//

import UIKit

protocol HomeDisplayLogic: AnyObject {
    func displayCheckUserPermission(viewModel: HomeModel.checkUserPermission.ViewModel)
    func displayCoreWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel)
    func didFailDisplaySavedWorkouts(withError message: StorageManagerError)
    func displaySavedWorkoutDetails(viewModel: HomeModel.ShowSavedWorkoutDetails.ViewModel)
    func displayRemoveWorkoutAlert(withMessage text: String)
    func didFailDisplayRemoveWorkoutAlert(withError message: StorageManagerError)
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
    private var coreWorkouts = [[CoreWorkoutViewModel]]()
    private var weekDays = [WeekDayModel]()
    
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
        makeWorkoutsRequest()
    }
    
    //MARK: - IBAction
    @IBAction func segmentControlTapped(_ sender: UISegmentedControl) {
        makeWorkoutsRequest(onSelectedSegmentIndex: sender.selectedSegmentIndex)
        reloadTableData()
    }
    
    //MARK: - Setup Methods
    private func setupView() {
        savedWorkoutsTableView.registerNib(class: HomeWorkoutCell.self)
    }
    
    private func setupSavedWorkouts(data: [[CoreWorkoutViewModel]], weekDays: [WeekDayModel]) {
        self.coreWorkouts = data
        self.weekDays = weekDays
        reloadTableData()
    }
    
    //MARK: - Request Methods
    private func checkUserPermission() {
        notificationManager.checkUserPermission { [weak self] granted in
            let request = HomeModel.checkUserPermission.Request(granted: granted)
            self?.interactor?.checkUserPermission(request: request)
        }
    }
    
    private func makeWorkoutsRequest(onSelectedSegmentIndex index: Int = 0) {
        let request = HomeModel.GetSavedWorkouts.Request(index: index)
        interactor?.getCoreWorkouts(request: request)
    }
    
    private func reloadTableData() {
        savedWorkoutsTableView.reloadData()
    }
}

//MARK: - HeaderView Delegate protocol
extension HomeViewController: notificationReceivedProtocol {
    
    func dismissCheckMark(cell: HomeWorkoutCell) {
        if let indexPath = savedWorkoutsTableView.indexPath(for: cell) {
            let currentSavedWorkout = coreWorkouts[indexPath.section][indexPath.row]
            interactor?.toggleMissedWorkout(false, weekDay: currentSavedWorkout.weekDay.name, id: currentSavedWorkout.id)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) { [weak self] in
                if let selectedIndex = self?.homeSegmentControl.selectedSegmentIndex {
                    self?.makeWorkoutsRequest(onSelectedSegmentIndex: selectedIndex)
                }
            }
        }
    }
    
    func appearMissedWorkouts(cell: HomeWorkoutCell, weekDay: String) {
        if let indexPath = savedWorkoutsTableView.indexPath(for: cell) {
            let currentSavedWorkout = coreWorkouts[indexPath.section][indexPath.row]
            if currentSavedWorkout.weekDay.name == weekDay {
                interactor?.toggleMissedWorkout(true, weekDay: currentSavedWorkout.weekDay.name, id: currentSavedWorkout.id)
                DispatchQueue.main.async { [weak self] in
                    self?.makeWorkoutsRequest()
                }
            }
        }
    }
}

//MARK: - Cell Delegate protocol
extension HomeViewController: updateHeaderDataProtocol {
    
    func getScheduledTime() {
        makeWorkoutsRequest()
    }
}

//MARK: - Display Logic protocol
extension HomeViewController: HomeDisplayLogic {
    
    func displayCheckUserPermission(viewModel: HomeModel.checkUserPermission.ViewModel) {
        notificationManager.deniedNotificationAlert(onVC: self)
    }
    
    func displayCoreWorkouts(viewModel: HomeModel.GetSavedWorkouts.ViewModel) {
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
    
    func didFailDisplayToggleMissedWorkout(withError message: StorageManagerError) {
        router?.routeToShowAlert(withTitle: message.rawValue, success: false)
    }
}

//MARK: - TableView Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentWorkout = coreWorkouts[indexPath.section][indexPath.row]
        let request = HomeModel.ShowSavedWorkoutDetails.Request(savedWorkout: currentWorkout)
        interactor?.getSavedWorkoutDetails(request: request)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = WeekDayHeaderView()
        view.configure(weekDay: weekDays[section])
        view.workoutCategories = coreWorkouts[section].map({$0.category.name})
        view.delegate = self
        
        return view
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
}

//MARK: - TableView DataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coreWorkouts[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as HomeWorkoutCell
        let currentWorkout = coreWorkouts[indexPath.section][indexPath.row]
        cell.configure(with: currentWorkout)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, homeSegmentControl.selectedSegmentIndex == 0 {
            let currentWorkout = coreWorkouts[indexPath.section][indexPath.row]
            interactor?.removeWorkout(withId: currentWorkout.id)
            self.coreWorkouts[indexPath.section].remove(at: indexPath.row)
            if coreWorkouts[indexPath.section].isEmpty {
                coreWorkouts.remove(at: indexPath.section)
                weekDays.remove(at: indexPath.section)
            }
            self.reloadTableData()
        }
    }
}
