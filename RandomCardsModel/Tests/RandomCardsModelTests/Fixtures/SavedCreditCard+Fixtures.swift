//
//  SavedCreditCard+Fixtures.swift
//
//
//  Created by Ant Gardiner on 10/11/23.
//

import Foundation
import CoreData
@testable import RandomCardsModel

extension SavedCreditCard {
	
	static func create(persistence: PersistenceController) -> SavedCreditCard {
		let context = persistence.container.viewContext
		return SavedCreditCard.create(context: context)
	}

	static func card1() -> SavedCreditCard {
		return create(persistence: PersistenceController.test)
			.set(id: 1)
			.set(uid: "1")
			.set(number: "1111-2222-3333-4444")
			.set(expiryDate: "2009-11-21")
			.set(type: "visa")
	}
	
	static func card2() -> SavedCreditCard {
		return create(persistence: PersistenceController.test)
			.set(id: 2)
			.set(uid: "2")
			.set(number: "2222-1111-3333-4444")
			.set(expiryDate: "2009-11-21")
			.set(type: "mastercard")
	}

}
