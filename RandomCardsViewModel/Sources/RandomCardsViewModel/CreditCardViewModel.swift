//
//  CreditCardViewModel.swift
//  
//
//  Created by Ant Gardiner on 10/11/23.
//

import Foundation
import Combine
import CoreData
import RandomCardsAPI
import RandomCardsModel

public enum SavedCardError: Error {
	case failedToAdd
	case failedToDelete
}

/// This protocol alllows us to create fake view models for testing the UI
public protocol CreditCardProtocol: ObservableObject {
	
	var number: String { get set }
	var expiryDate: String { get set }
	var type: String { get set }
	var saved: Bool { get set }
	
	func toggleSave(context: NSManagedObjectContext)
}

public class CreditCardViewModel: CreditCardProtocol {

	public var id: Int64
	public var uid: String
	
	@Published public var number: String
	@Published public var expiryDate: String
	@Published public var type: String
	@Published public var saved: Bool = false
	
	private(set) public static var cardsDeletedSubject = CurrentValueSubject<[Int64], Never>([])
	public static var cardsDeletedPublisher: AnyPublisher<[Int64], Never> = {
		cardsDeletedSubject.eraseToAnyPublisher()
	}()
	
	/// Keep a reference to saved card if it exists.
	private var savedCreditCard: SavedCreditCard?
	
	/// Create a view model for a random card
	/// - Parameters:
	///   - id: unique it
	///   - uid: uuid of this case
	///   - number: the credit card number
	///   - expiryDate: the expiry data
	///   - type: the type of card
	///   - saved: true if saved
	public init(id: Int64, uid: String, number: String, expiryDate: String, type: String, saved: Bool) {
		self.id = id
		self.uid = uid
		self.number = number
		self.expiryDate = expiryDate
		self.type = type
		self.saved = saved
	}
	
	/// Create a view model from a credit card
	/// - Parameter creditCard: the creidut credit to use
	public init(creditCard: CreditCard) {
		self.id = Int64(creditCard.id)
		self.uid = creditCard.uid
		self.number = creditCard.creditCardNumber
		self.expiryDate = creditCard.creditCardExpiryDate
		self.type = creditCard.creditCardType
		self.saved = false
		checkSaved()
	}
	
	/// Create a view model from a saved credit card
	/// - Parameter savedCreditCard: the saved cedit card to use
	public init(savedCreditCard: SavedCreditCard) {
		// These should not be nil a hang up of Core Data model being optional
		self.id = savedCreditCard.id 
		self.uid = savedCreditCard.uid ?? ""
		self.number = savedCreditCard.number ?? ""
		self.expiryDate = savedCreditCard.expiryDateString ?? ""
		self.type = savedCreditCard.type ?? ""
		self.savedCreditCard = savedCreditCard
		self.saved = true
	}
	
	/// Check that this card is save or not.
	/// Done async and updates saved property if saved.
	func checkSaved() {
		Task {
			let saved = (try? SavedCreditCard.findSavedCreditCard(by: id) != nil) ?? false
			await updateSaved(saved:saved)
		}
	}
	
	@MainActor
	/// Update the saved property on the main actor - for UI thread safety
	/// - Parameter saved: is the card saved.
	func updateSaved(saved: Bool) {
		self.saved = saved
	}
	
	/// Toogle saved state may add or delete a saved card entoty
	/// - Parameter context: the managed object context to use
	public func toggleSave(context: NSManagedObjectContext) {
		
		// remove card
		if saved {
			// Delete the card record
			do {
				try self.delete(context: context)
			}
			catch {
				let nsError = error as NSError
				fatalError("failed to delete error \(nsError), \(nsError.userInfo)")
			}
		}
		// add card
		else {
			add(context: context)
		}
	}
	
	/// Add a saved credit card
	/// - Parameter context: the managed object context to use
	public func add(context: NSManagedObjectContext) {
		savedCreditCard = SavedCreditCard.create(context: context)
			.set(id: id)
			.set(uid: uid)
			.set(number: number)
			.set(expiryDate: expiryDate)
			.set(type: type)
		
		save(context: context)
	}
	
	/// Delete a saved credit card
	/// - Parameter context: the managed object context to use
	public func delete(context: NSManagedObjectContext) throws {
		
		guard let savedCreditCard else {
			// not saved so do nothing
			throw SavedCardError.failedToDelete
		}
		
		// Keep a record of the id that is being deleted.
		let id = savedCreditCard.id
		
		context.delete(savedCreditCard)
		save(context: context)
		self.savedCreditCard = nil

		// Publish delete to anyone that is listening.
		CreditCardViewModel.cardsDeletedSubject.value = [id]		
	}
	
	/// Save the context and toggle the saved state
	/// - Parameter context: managed object context to use
	private func save(context: NSManagedObjectContext) {
		do {
			try context.save()
			saved.toggle()
		} catch {
			
			let nsError = error as NSError
			fatalError("failed to save error \(nsError), \(nsError.userInfo)")
		}
	}
}
