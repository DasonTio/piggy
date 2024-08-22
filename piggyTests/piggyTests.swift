//
//  piggyTests.swift
//  piggyTests
//
//  Created by Dason Tiovino on 13/08/24.
//

import Combine
import XCTest
import SwiftData
@testable import piggy

final class LocalTransactionListTest: XCTestCase {

    private var useCase: TransactionListUseCase!
    private var repository: TransactionListRepository!
    private var cancellables = Set<AnyCancellable>()
    private var newId: String!

    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: TransactionListLocalEntity.self, configurations: config)

        repository = DefaultTransactionListRepository(container: container)
        useCase = DefaultTransactionListUseCase(repository: repository)
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
            XCTAssertEqual(response[0].title, "TestTitle")
        }
        .store(in: &cancellables)
    }
    
    func testAddList(){
        let response = useCase.save(params: SaveTransactionListRequest(
            title: "TestTitle",
            amount: 10000,
            category: "TestCategory")
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
            XCTAssertEqual(response[0].title, "TestTitle")
        }.store(in: &cancellables)
        
        let response = useCase.update(params: UpdateTransactionListRequest(
            id: "19170CEC-A92B-4D04-9EC2-0692A42FD32A",
            title: "newTitle",
            amount: 20000,
            category: "NewCategory")
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
