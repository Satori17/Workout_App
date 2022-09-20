//
//  CategoryPresenterTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 20.09.22.
//

import XCTest
@testable import Workout_App

final class CategoryPresenterTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: CategoryPresenter!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        setupCategoryPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Test Setup
    private func setupCategoryPresenter() {
        sut = CategoryPresenter()
    }
    
    //MARK: - Tests
    func testPresentCategoriesShouldDisplayCategories() {
        //Given
        let categoryDisplayLogicSpy = CategoryDisplayLogicSpy()
        sut.viewController = categoryDisplayLogicSpy
        
        //When
        sut.presentCategories(response: CategoryModel.GetCategories.Response(categories: []))
        
        //Then
        XCTAssertTrue(categoryDisplayLogicSpy.displayCategoriesCalled)
    }
    
    func testDidFailPresentCategoriesShouldDisplayDidFailCategory() {
        //Given
        let categoryDisplayLogicSpy = CategoryDisplayLogicSpy()
        sut.viewController = categoryDisplayLogicSpy
        
        //When
        sut.didFailPresentCategories(withError: FetchingError.dataError)
        
        //Then
        XCTAssertTrue(categoryDisplayLogicSpy.didFailDisplayCategoriesCalled)
    }
    
    func testPresentCategoryWorkoutsShouldDisplayCategoryWorkouts() {
        //Given
        let categoryDisplayLogicSpy = CategoryDisplayLogicSpy()
        sut.viewController = categoryDisplayLogicSpy
        
        //When
        sut.presentCategoryWorkouts(response: CategoryModel.ShowCategoryWorkouts.Response())
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertTrue(categoryDisplayLogicSpy.displayCategoryWorkoutsCalled)
        }
    }
}

//MARK: - Test Doubles
private final class CategoryDisplayLogicSpy: CategoryDisplayLogic {
    
    var displayCategoriesCalled = false
    func displayCategories(viewModel: CategoryModel.GetCategories.ViewModel) {
        displayCategoriesCalled = true
    }
    
    var didFailDisplayCategoriesCalled = false
    func didFailDisplayCategory(withError message: FetchingError) {
        didFailDisplayCategoriesCalled = true
    }
    
    var displayCategoryWorkoutsCalled = false
    func displayCategoryWorkouts(viewModel: CategoryModel.ShowCategoryWorkouts.ViewModel) {
        displayCategoriesCalled = true
    }
}
