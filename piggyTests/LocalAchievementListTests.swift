//
//  LocalAchievementListTests.swift
//  piggyTests
//
//  Created by Dason Tiovino on 15/08/24.
//

import Combine
import XCTest
import SwiftData
@testable import piggy

final class LocalAchievementListTests: XCTestCase {
    
    private var useCase: AchievementListUseCase!
    private var repository: AchievementListRepository!
    private var cancellables = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: AchievementListLocalEntity.self, configurations: config)

        repository = DefaultAchievementListRepository(container: container)
        useCase = DefaultAchievementListUseCase(repository: repository)
    }

    override func tearDownWithError() throws {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetList() {
        let response = useCase.fetch()

        response.sink { _ in
        } receiveValue: { response in
            guard let response = response else {
                return XCTFail("Failed to get note list response")
            }
            XCTAssertEqual(response[0].title, "Hello")
        }
        .store(in: &cancellables)
    }
    
    func testAddList(){
        let response = useCase.save(params: SaveAchievementListRequest(
            title: "TestAchievementTitle",
            category: "TestAchievementCategory")
        )
        
        response.sink { _ in
        }receiveValue: { response in
            XCTAssertEqual(response, true)
        }
        .store(in: &cancellables)
    }
    
    
    func testUpdateList(){
        let fetchResponse = useCase.fetch()
        
        fetchResponse.sink{_ in
        }receiveValue: { response in
            guard let response = response else {
                return XCTFail("Failed to get note list response")
            }
            XCTAssertEqual(response[0].title, "TestAchievementTitle")
        }.store(in: &cancellables)
        
        let response = useCase.update(params: UpdateAchievementListRequest(
            id: "8EB6287E-C034-4AF5-9BAE-F041D2707E0C",
            title: "newAchievementTitle",
            category: "newAchievementCategory")
        )
        
        response.sink{_ in
        }receiveValue: { response in
            XCTAssertEqual(response, true)
            
            let fetchResponse = self.useCase.fetch()
            fetchResponse.sink { _ in
            } receiveValue: { response in
                guard let response = response else {
                    return XCTFail("Failed to get note list response")
                }
                XCTAssertEqual(
                    response.first(
                        where: {
                            $0.id == "19170CEC-A92B-4D04-9EC2-0692A42FD32A"
                        }
                    )!.title,
                    "newTitle",
                    "The title of the selected item should be updated"
                )
            }.store(in: &self.cancellables)
        }.store(in: &cancellables)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
