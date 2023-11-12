//
//  RandomCardsAPITests.swift
//
//
//  Created by Ant Gardiner on 9/11/23.
//

import XCTest
@testable import RandomCardsAPI

final class RandomCardsAPITests: XCTestCase {
	
	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testGetRandomCardsServerError() async throws {
		
		let session = MockURLSession()
		
		// Given
		session.statusCode = 300
		
		// When
		var result = try await RandomCardsAPI.getRandomCreditCards(session: session)
		
		// Then
		if case .failure(let error) = result {
			XCTAssertEqual(error.value, 300)
		}
		else {
			XCTFail("Unexpected success.")
		}


		// Given
		session.statusCode = 199
		
		// When
		result = try await RandomCardsAPI.getRandomCreditCards(session: session)
		
		// Then
		if case .failure(let error) = result {
			XCTAssertEqual(error.value, 199)
		}
		else {
			XCTFail("Unexpected success.")
		}
	}
	
	func testGetRandomCards() async throws {
		
		let session = MockURLSession()
		
		// Given
		session.statusCode = 200
		
		// When
		let result = try await RandomCardsAPI.getRandomCreditCards(session: session)
		
		// Then
		if case .success(let creditCards) = result {
			XCTAssert(creditCards.count == 10)
		}
		else {
			XCTFail("Unexpected failure.")
		}
	}
}

// Create a mock for URLSession.
class MockURLSession: URLSessionProtocol {
	
	var statusCode = 200
	
	func data(
		for request: URLRequest,
		delegate: (URLSessionTaskDelegate)? = nil
	) async throws -> (Data, URLResponse) {
	
		let response = HTTPURLResponse(url: request.url!, statusCode: statusCode, httpVersion: "", headerFields: [:])!

		if statusCode == 200 {
			let jsonURL = try XCTUnwrap(URL.fitURL(name: "random-cards", ext: "json"))
			let data = try XCTUnwrap(Data(contentsOf: jsonURL))
			return (data, response)
		}
		return (Data(), response)
	}
}

