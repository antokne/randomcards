//
//  CardSortOrderTests.swift
//
//
//  Created by Ant Gardiner on 10/11/23.
//

import XCTest
@testable import RandomCardsAPI

final class CardSortOrderTests: XCTestCase {
	
	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testSortOrder() throws {
		
		let card1 = CreditCard(id: 0,
							   uid: "1",
							   creditCardNumber: "2222-1111-3333-4444",
							   creditCardExpiryDate: "21-11-2025",
							   creditCardType: "mastercard")
		let card2 = CreditCard(id: 1,
							   uid: "2",
							   creditCardNumber: "1111-2222-3333-4444",
							   creditCardExpiryDate: "21-11-2025",
							   creditCardType: "visa")

		let cards = [
			card1,
			card2
		]
		
		let orderByNumber = cards.sort(by: .number)
		XCTAssertEqual(orderByNumber.first, card2)

		let orderByType = orderByNumber.sort(by: .type)
		XCTAssertEqual(orderByType.first, card1)

		
	}
	
	
	
}
