//
//  CreditCard.swift
//  
//
//  Created by Ant Gardiner on 8/11/23.
//

import Foundation

/// Simple CreditCard struct to convert from JSON
/// In a more realistic case we could actually convert some of these into
/// better names and types.
/// Kept it simple for the purpose of this exercise.
public struct CreditCard: Codable, Identifiable {
	public let id: Int // This needs to be unique!
	public let uid: String
	public let creditCardNumber: String
	public let creditCardExpiryDate: String
	public let creditCardType: String
}

extension CreditCard: Equatable {
	
}
