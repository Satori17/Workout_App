//
//  CategoryRouterTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 20.09.22.
//

import XCTest
@testable import Workout_App

final class CategoryRouterTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: CategoryRouter!
    private var navigationController: UINavigationControllerMock!
    private var source: SourceViewControllerMock!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        setupCategoryRouter()
    }
    
    override func tearDown() {
        super.tearDown()
        source = nil
        sut = nil
        navigationController = nil
    }
    
    //MARK: - Test Setup
    private func setupCategoryRouter() {
        source = SourceViewControllerMock()
        navigationController = UINavigationControllerMock(rootViewController: source)
        sut = CategoryRouter()
        sut.viewController = source
    }
    
    //MARK: - Tests
    func testGivenRouterWhenRouteToWorkoutsCalled() {
        //Given
        
        //When
        sut.routeToWorkouts()
        
        //Then
        XCTAssertTrue(navigationController.pushViewControllerCalled)
    }
    
    func testGivenRouterWhenRouteToShowAlertCalled() {
        //Given
        
        //When
        sut.routeToShowAlert(withTitle: CustomTitle.empty, success: false)
        
        //Then
            XCTAssertTrue(self.source.presentCalled)
    }
}

//MARK: - Test Doubles
private final class UINavigationControllerMock: UINavigationController {
    var pushViewControllerCalled = false
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
    }
}

private final class SourceViewControllerMock: UINavigationController {
    var presentCalled = false
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        presentCalled = true
    }
}
