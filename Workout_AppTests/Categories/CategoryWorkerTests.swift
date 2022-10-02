//
//  CategoryWorkerTests.swift
//  Workout_AppTests
//
//  Created by Saba Khitaridze on 03.10.22.
//

import XCTest
@testable import Workout_App

final class CategoryWorkerTests: XCTestCase {
    
    //MARK: - Subject Under Test
    private var sut: CategoryWorker!
    
    //MARK: - Test Lifecycle
    override func setUp() {
        super.setUp()
        setupCategoryWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    //MARK: - Test Setup
    private func setupCategoryWorker() {
        sut = CategoryWorker()
    }
    
    //MARK: - Tests
    func testFetchCategoriesShouldReturnCategories() async throws {
        do {
            //When
            let result = try await sut.fetchCategories()
            
            //Then
            XCTAssertNotNil(result)
            XCTAssertEqual(result.count, 7)
        } catch {
            XCTAssertEqual(error as? FetchingError, .dataError)
        }
    }
}
