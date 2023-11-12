//
//  Array+CreditCard.swift
//
//
//  Created by Ant Gardiner on 10/11/23.
//

import Foundation

public extension Array where Element == CreditCard {
	
	/// Sort the array of cards.
	/// To be honest I'd rather send this sort order to the cloud call.
	/// - Parameter sortOrder: sort order to use
	/// - Returns: an order list of cards
	func sort(by sortOrder: CardSortOrder) -> [CreditCard] {
		switch sortOrder {
		case .number:
			return self.sorted(by: { $0.creditCardNumber < $1.creditCardNumber })
		case .type:
			return self.sorted(by: { $0.creditCardType < $1.creditCardType })
		}
	}
	
}
