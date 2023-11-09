//
//  CreditCardTests.swift
//  
//
//  Created by Ant Gardiner on 9/11/23.
//

import XCTest
@testable import RandomCardsAPI

final class CreditCardTests: XCTestCase {

	override func setUpWithError() throws {
	}
	
	override func tearDownWithError() throws {
	}
	
	func testDecodeCard() throws {
		let json = """
		{
			"id": 4726,
			"uid": "b329f0cc-29ea-4185-bd19-d27eb7341b91",
			"credit_card_number": "1234-2121-1221-1211",
			"credit_card_expiry_date": "2025-11-07",
			"credit_card_type": "diners_club"
		}
		""".data(using: .utf8)!
		
		let creditCard: CreditCard = try json.decodeData()
		XCTAssertNotNil(creditCard)
		XCTAssertEqual(creditCard.id, 4726)
		XCTAssertEqual(creditCard.uid, "b329f0cc-29ea-4185-bd19-d27eb7341b91")
		XCTAssertEqual(creditCard.creditCardNumber, "1234-2121-1221-1211")
		XCTAssertEqual(creditCard.creditCardExpiryDate, "2025-11-07")
		XCTAssertEqual(creditCard.creditCardType, "diners_club")

	}
	
	func testDecodeCards() throws {
		let jsonURL = try XCTUnwrap(URL.fitURL(name: "random-cards", ext: "json"))
		
		XCTAssertTrue(FileManager.default.fileExists(atPath: jsonURL.path))
		
		let data = try XCTUnwrap(Data(contentsOf: jsonURL))
		
		let results:[CreditCard] = try data.decodeData()
		
		XCTAssertNotNil(results)
		XCTAssertEqual(results.count, 10)
	}

}
