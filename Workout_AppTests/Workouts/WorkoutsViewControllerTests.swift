//
//  WorkoutsViewControllerTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 20.09.22.
//

import XCTest
@testable import Workout_App

final class WorkoutsViewControllerTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: WorkoutsViewController!
    private var window: UIWindow!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        window = UIWindow()
        setupWorkoutsVC()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    //MARK: - Test Setup
    private func setupWorkoutsVC() {
        let storyboard = UIStoryboard(name: Ids.workouts, bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: Ids.workouts) as? WorkoutsViewController
    }
    
    private func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    //MARK: - Tests
    func testShouldGetWorkoutsWhenViewIsLoaded() {
        //Given
        let workoutsBusinessLogicSpy = WorkoutsBusinessLogicSpy()
        sut.interactor = workoutsBusinessLogicSpy
        
        //When
        loadView()
        
        //Then
        XCTAssert(workoutsBusinessLogicSpy.getWorkoutsCalled, "viewDidLoad through setupView should ask interactor to fetch workouts")
    }
    
    func testGetWorkoutsShouldReloadCollectionView() {
        //Given
        loadView()
        
        let collectionViewSpy = CollectionViewSpy()
        sut.workoutsCollectionView = collectionViewSpy
        
        //When
        sut.displayWorkouts(viewModel: WorkoutModel.GetWorkouts.ViewModel(displayedWorkouts: []))
        
        //Then
        XCTAssert(collectionViewSpy.reloadDataCalled, "getWorkouts() should reload the collectionView")
    }
    
    func testdidFailDisplayWorkoutsShouldCallRouteToShowAlert() {
        //Given
        loadView()
        
        let workoutsRoutingLogicSpy = WorkoutsRoutingLogicSpy()
        sut.router = workoutsRoutingLogicSpy
        
        //When
        sut.didFailDisplayWorkouts(withError: FetchingError.dataError)
        
        //Then
        XCTAssert(workoutsRoutingLogicSpy.routeToShowAlertCalled, "routeToShowAlert() should navigate to AlertViewController")
    }
    
    func testWorkoutCellSeeMoreBtnShouldShowWorkoutDetails() {
        //Given
        let workoutsBusinessLogicSpy = WorkoutsBusinessLogicSpy()
        sut.interactor = workoutsBusinessLogicSpy
        
        //When
        loadView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            if let cell = self.sut.collectionView(self.sut.workoutsCollectionView, cellForItemAt: IndexPath(item: 0, section: 0)) as? WorkoutCell {
                self.sut.getWorkoutDetails(cell: cell)
            }
            //Then
            XCTAssertTrue(workoutsBusinessLogicSpy.showWorkoutDetailsCalled)
        }
    }
    
    func testContextMenuAddWorkoutBtnShouldShowSaveAlert() {
        //Given
        let workoutsBusinessLogicSpy = WorkoutsBusinessLogicSpy()
        sut.interactor = workoutsBusinessLogicSpy
        
        //When
        loadView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let _ = self.sut.collectionView(self.sut.workoutsCollectionView, contextMenuConfigurationForItemAt: IndexPath(item: 0, section: 0), point: CGPoint(x: 0, y: 0))
            
            //Then
            XCTAssertTrue(workoutsBusinessLogicSpy.showSaveAlertCalled)
        }
    }
    
    func testContextMenuShouldInstantiateDetailsVC() {
        //Given
        let workoutsRoutingLogicSpy = WorkoutsRoutingLogicSpy()
        sut.router = workoutsRoutingLogicSpy
        
        //When
        loadView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let _ = self.sut.collectionView(self.sut.workoutsCollectionView, contextMenuConfigurationForItemAt: IndexPath(item: 0, section: 0), point: CGPoint(x: 0, y: 0))
            
            //Then
            XCTAssertTrue(workoutsRoutingLogicSpy.instantiateDetailsVCCalled)
        }
    }
    
    func testDisplayWorkoutDetailsShouldNavigateToWorkoutDetails() {
        //Given
        loadView()
        
        let workoutsRoutingLogicSpy = WorkoutsRoutingLogicSpy()
        sut.router = workoutsRoutingLogicSpy
        
        //When
        sut.displayWorkoutDetails(viewModel: WorkoutModel.ShowWorkoutDetails.ViewModel())
        
        //Then
        XCTAssert(workoutsRoutingLogicSpy.routeToWorkoutDetailsCalled, "routeToWorkoutDetails() should navigate user to WorkoutDetailsViewController")
    }
    
    func testContextMenuAddWorkoutBtnShouldNavigateToSaveAlert() {
        //Given
        let workoutsRoutingLogicSpy = WorkoutsRoutingLogicSpy()
        sut.router = workoutsRoutingLogicSpy
        
        //When
        loadView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let _ = self.sut.collectionView(self.sut.workoutsCollectionView, contextMenuConfigurationForItemAt: IndexPath(item: 0, section: 0), point: CGPoint(x: 0, y: 0))
            
            //Then
            XCTAssertTrue(workoutsRoutingLogicSpy.routeToSaveAlertCalled)
        }
    }
}

//MARK: - Test Doubles
private final class CollectionViewSpy: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = UICollectionViewLayout()
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var reloadDataCalled = false
    override func reloadData() {
        reloadDataCalled = true
    }
}

private final class WorkoutsBusinessLogicSpy: WorkoutsBusinessLogic {
    
    var getWorkoutsCalled = false
    func getWorkouts(request: WorkoutModel.GetWorkouts.Request) {
        getWorkoutsCalled = true
    }
    
    var showWorkoutDetailsCalled = false
    func showWorkoutDetails(request: WorkoutModel.ShowWorkoutDetails.Request) {
        showWorkoutDetailsCalled = true
    }
    
    var showSaveAlertCalled = false
    func showSaveAlert(request: WorkoutModel.ShowSaveAlert.Request) {
        showSaveAlertCalled = true
    }
}

private final class WorkoutsRoutingLogicSpy: WorkoutsRoutingLogic, WorkoutsDataPassing {
    var dataStore: WorkoutsDataStore?
    
    var instantiateDetailsVCCalled = false
    func instantiateDetailsVC(withWorkout workout: WorkoutViewModel) -> WorkoutDetailViewController {
        instantiateDetailsVCCalled = true
        return WorkoutDetailViewController()
    }
    
    var routeToWorkoutDetailsCalled = false
    func routeToWorkoutDetails() {
        routeToWorkoutDetailsCalled = true
    }
    
    var routeToSaveAlertCalled = false
    func routeToSaveAlert() {
        routeToSaveAlertCalled = true
    }
    
    var routeToShowAlertCalled = false
    func routeToShowAlert(withTitle text: String, success: Bool) {
        routeToShowAlertCalled = true
    }
}
