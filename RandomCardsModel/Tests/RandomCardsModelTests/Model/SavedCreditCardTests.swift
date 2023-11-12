//
//  SavedCreditCardTests.swift
//
//
//  Created by Ant Gardiner on 9/11/23.
//

import XCTest
@testable import RandomCardsModel

final class SavedCreditCardTests: XCTestCase {
	
	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testCreate() throws {

		let savedCard = SavedCreditCard.create(persistence: PersistenceController.test)
			.set(id: 123456)
			.set(uid: "ABCDEF")
			.set(number: "1234-5678")
			.set(expiryDate: "2009-11-21")
			.set(type: "visa")
		
		XCTAssertNotNil(savedCard)
		XCTAssertEqual(savedCard.id, 123456)
		XCTAssertEqual(savedCard.uid, "ABCDEF")
		XCTAssertEqual(savedCard.number, "1234-5678")
		XCTAssertEqual(savedCard.expiryDate?.timeIntervalSinceReferenceDate, 254142000.0)
		XCTAssertEqual(savedCard.type, "visa")
		XCTAssertNotNil(savedCard.insertDate)
		XCTAssertNotNil(savedCard.updatedDate)
	}
	
	func testFindAndDelete() throws {
		
		let card1 = SavedCreditCard.card1()
		
		var foundCard = try SavedCreditCard.findSavedCreditCard(by: card1.id, context: PersistenceController.test.container.viewContext)
		
		XCTAssertEqual(card1, foundCard)
		
		foundCard?.delete()
		
		foundCard = try SavedCreditCard.findSavedCreditCard(by: card1.id, context: PersistenceController.test.container.viewContext)
		
		XCTAssertNil(foundCard)
		
		
	}
	
}
