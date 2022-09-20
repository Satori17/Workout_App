//
//  CategoryInteractorTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 20.09.22.
//

import XCTest
@testable import Workout_App

final class CategoryInteractorTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: CategoryInteractor!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        setupCategoryInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Test Setup
    private func setupCategoryInteractor() {
        sut = CategoryInteractor()
    }
    
    //MARK: - Tests
    func testgetCategoriesShouldAskWorkertoFetchCategories() async {
        //Given
        let categoryPresentationLogicSpy = categoryPresentationLogicSpy()
        sut.presenter = categoryPresentationLogicSpy
        
        //Then
        do {
            let data = try await sut.worker?.fetchCategories()
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                XCTAssertNotNil(data)
            }
        } catch {
            XCTAssertEqual(error as? FetchingError, .dataError)
        }
    }
    
    func testGetCategoriesShouldPresentCategories() {
        //Given
        let categoryPresentationLogicSpy = categoryPresentationLogicSpy()
        sut.presenter = categoryPresentationLogicSpy
        
        //When
        sut.getCategories(request: CategoryModel.GetCategories.Request())
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertTrue(categoryPresentationLogicSpy.presentCategoriesCalled, "get categories should ask presenter to present categories")
        }
    }
    
    func testGetCategoriesShouldPresentDidFailPresentCategories() {
        //Given
        let categoryPresentationLogicSpy = categoryPresentationLogicSpy()
        sut.presenter = categoryPresentationLogicSpy
        
        //When
        sut.getCategories(request: CategoryModel.GetCategories.Request())
        
        //Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertTrue(categoryPresentationLogicSpy.didFailPresentCategoriesCalled, "get categories should ask presenter to present didFailPresentCategories")
        }
    }
    
    func testShowCategoryWorkoutsShouldPresentCategoryWorkouts() {
        //Given
        let categoryPresentationLogicSpy = categoryPresentationLogicSpy()
        sut.presenter = categoryPresentationLogicSpy
        
        //When
        sut.showCategoryWorkouts(request: CategoryModel.ShowCategoryWorkouts.Request(id: 0, name: CustomTitle.empty))
        
        //Then
        XCTAssertTrue(categoryPresentationLogicSpy.showCategoryWorkoutsCalled, "show category workouts should ask presenter to present category workouts")
    }
}

//MARK: - Test Doubles
private final class categoryPresentationLogicSpy: CategoryPresentationLogic {
    
    var presentCategoriesCalled = false
    func presentCategories(response: CategoryModel.GetCategories.Response) {
        presentCategoriesCalled = true
    }
    
    var didFailPresentCategoriesCalled = false
    func didFailPresentCategories(withError message: FetchingError) {
        didFailPresentCategoriesCalled = true
    }
    
    var showCategoryWorkoutsCalled = false
    func presentCategoryWorkouts(response: CategoryModel.ShowCategoryWorkouts.Response) {
        showCategoryWorkoutsCalled = true
    }
}
