//
//  SavedCreditCard+Extension.swift
//
//
//  Created by Ant Gardiner on 9/11/23.
//

import Foundation
import CoreData

public extension SavedCreditCard {
	
	static func create(context: NSManagedObjectContext) -> SavedCreditCard {
		let card = SavedCreditCard(context: context)
		card.insertDate = Date()
		return card
	}
	
	@discardableResult
	func set(id: Int64) -> SavedCreditCard {
		self.id = id
		self.updatedDate = Date()
		return self
	}
	
	@discardableResult
	func set(uid: String) -> SavedCreditCard {
		self.uid = uid
		self.updatedDate = Date()
		return self
	}

	@discardableResult
	func set(number: String) -> SavedCreditCard {
		self.number = number
		self.updatedDate = Date()
		return self
	}
	
	@discardableResult
	func set(expiryDate: String) -> SavedCreditCard {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-DD"
		self.expiryDate = dateFormatter.date(from: expiryDate)
		self.updatedDate = Date()
		return self
	}
	
	// might convert card type to it's own model in real world scenario.
	@discardableResult
	func set(type: String) -> SavedCreditCard {
		self.type = type
		self.updatedDate = Date()
		return self
	}
	
	var expiryDateString: String? {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "YYYY-MM-DD"
		if let expiryDate {
			return dateFormatter.string(from: expiryDate)
		}
		return nil
	}

	static func findSavedCreditCard(by id: Int64, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> SavedCreditCard? {
		let fetchRequest = NSFetchRequest<SavedCreditCard>(entityName: SavedCreditCard.className)
		fetchRequest.predicate = \SavedCreditCard.id == id
		let result = try context.fetch(fetchRequest)
		return result.first
	}
	
	func delete() {
		let context = self.managedObjectContext
		context?.delete(self)
	}
	
	class func sortedFetchRequest(cardType: String? = nil) -> NSFetchRequest<SavedCreditCard> {
		
		let fetchRequest = NSFetchRequest<SavedCreditCard>(entityName: SavedCreditCard.className)
		
		if let cardType {
			fetchRequest.predicate = \SavedCreditCard.type == cardType
		}
		
		let sortDescriptor = NSSortDescriptor(keyPath: \SavedCreditCard.updatedDate, ascending: true)
		fetchRequest.sortDescriptors = [sortDescriptor]
		
		return fetchRequest
	}
}
