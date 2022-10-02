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
        super.setUp()
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
    
    //MARK: - New
    func testNumberOfRowsShouldEqualNumberOfCategoriesToDisplay() {
        // Given
        loadView()
        
        let tableViewSpy = TableViewSpy()
        let categoriesDataMock: [CategoryViewModel] = [CategoryViewModel(id: 0, name: "test")]
        sut.displayCategories(viewModel: CategoryModel.GetCategories.ViewModel(displayedCategories: categoriesDataMock))
        
        //When
        let numberOfRows = sut.tableView(tableViewSpy, numberOfRowsInSection: 1)
        
        //Then
        XCTAssertEqual(numberOfRows, categoriesDataMock.count, "The number of tableView rows should equal the number of movies to display")
    }
    
    //MARK: - New
    func testShouldConfigureCategoryCellToDisplayCategories() {
        // Given
        loadView()
        let tableViewSpy = TableViewSpy()
        tableViewSpy.registerNib(class: CategoryCell.self)
        let categoriesDataMock: [CategoryViewModel] = [CategoryViewModel(id: 0, name: "test")]
        let viewModel = CategoryModel.GetCategories.ViewModel(displayedCategories: categoriesDataMock)
        sut.displayCategories(viewModel: viewModel)
        
        //When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableViewSpy, cellForRowAt: indexPath) as? CategoryCell
        
        //Then
        XCTAssertEqual(cell?.categoryNameLabel.text, "\(CustomTitle.space)test", "categoriesTableView cell should display category name properly")
        XCTAssertEqual(cell?.categoryImageView.image, UIImage(), "categoriesTableView cell should display category images depend on its name properly" )
    }
    
    func testdidFailDisplayCategoryShouldCallRouteToShowAlert() {
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
        categoryBusinessLogicSpy.showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request(id: 0, name: CustomTitle.empty))
        
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
    
    var reloadDataCalled = false
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
    
    var routeToShowAlertCalled = false
    func routeToShowAlert(withTitle text: String, success: Bool) {
        routeToShowAlertCalled = true
    }
}
