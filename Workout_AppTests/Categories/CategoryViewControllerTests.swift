//
//  CategoryViewControllerTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 20.09.22.
//

import XCTest
@testable import Workout_App

final class CategoryViewControllerTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: CategoryViewController!
    private var window: UIWindow!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        window = UIWindow()
        setupCategoryVC()
    }
    
    override func tearDown() {
        window = nil
        super.tearDown()
    }
    
    //MARK: - Test Setup
    private func setupCategoryVC() {
        let storyboard = UIStoryboard(name: Ids.category, bundle: nil)
        sut = storyboard.instantiateViewController(withIdentifier: Ids.category) as? CategoryViewController
    }
    
    private func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    //MARK: - Tests
    func testShouldGetCategoriesWhenViewIsLoaded() {
        //Given
        let categoryBusinessLogicSpy = CategoryBusinessLogicSpy()
        sut.interactor = categoryBusinessLogicSpy
        
        //When
        loadView()
        
        //Then
        XCTAssert(categoryBusinessLogicSpy.getCategoriesCalled, "ViewDidLoad thourgh setupView() should ask interactor to fetch categories")
    }
    
    func testGetCategoriesShouldReloadTableView() {
        //Given
        loadView()
        
        let tableViewSpy = TableViewSpy()
        sut.categoriesTableView = tableViewSpy
        
        //When
        sut.displayCategories(viewModel: CategoryModel.GetCategories.ViewModel(displayedCategories: []))
        
        //Then
        XCTAssert(tableViewSpy.reloadDataCalled, "getCategories() should reload the tableView")
    }

    func testdidFailDisplayCategoryShouldCallrouteToShowAlert() {
        //Given
        loadView()
        
        let categoriesRoutingLogicSpy = CategoryRoutingLogicSpy()
        sut.router = categoriesRoutingLogicSpy
        
        //When
        sut.didFailDisplayCategory(withError: FetchingError.dataError)
        
        //Then
        XCTAssert(categoriesRoutingLogicSpy.routeToShowAlertCalled, "routeToShowAlert() should navigate to AlertViewController")
    }
    
    func testCategoryCellDidSelectShouldShowCategoryWorkouts() {
        //Given
        loadView()
        
        let categoryBusinessLogicSpy = CategoryBusinessLogicSpy()
        sut.interactor = categoryBusinessLogicSpy
        
        //When
        categoryBusinessLogicSpy.showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request(id: 0, name: ""))
        
        //Then
        XCTAssert(categoryBusinessLogicSpy.showCategoryWorkoutsCalled, "showWorkoutCategories() should show categorized workouts")
    }
    
    func testCategoryCellDidSelectShouldNavigateToWorkouts() {
        //Given
        loadView()
        
        let categoryRoutingLogicSpy = CategoryRoutingLogicSpy()
        sut.router = categoryRoutingLogicSpy
        
        //When
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.sut.tableView(self.sut.categoriesTableView, didSelectRowAt: IndexPath(row: 0, section: 0))
            
            XCTAssert(categoryRoutingLogicSpy.routeToWorkoutsCalled, "CategoryTableView delegate didSelectRowAt method should navigate user to WorkoutsViewController")
        }
    }
}

//MARK: - Test Doubles
private final class TableViewSpy: UITableView {
    
    // MARK: Method call condition
    var reloadDataCalled = false

    // MARK: Spied Methods
    override func reloadData() {
        super .reloadData()
        reloadDataCalled = true
    }
}

private final class CategoryBusinessLogicSpy: CategoryBusinessLogic {
    
    var getCategoriesCalled = false
    func getCategories(request: CategoryModel.GetCategories.Request) {
        getCategoriesCalled = true
    }
    
    var showCategoryWorkoutsCalled = false
    func showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request) {
        showCategoryWorkoutsCalled = true
    }
}

private final class CategoryRoutingLogicSpy: CategoryRoutingLogic, CategoryDataPassing {
    var dataStore: CategoryDataStore?
    
    var routeToWorkoutsCalled = false
    func routeToWorkouts() {
        routeToWorkoutsCalled = true
    }
    
    var routeToShowAlertCalled = false//
    func routeToShowAlert(withTitle text: String, success: Bool) {
        routeToShowAlertCalled = true
    }
}
