//
//  RandomCardsViewModel.swift
//  RandomCardsViewModel
//
//  Created by Ant Gardiner on 9/11/23.
//

import Foundation
import Combine
import CoreData
import RandomCardsAPI
import RandomCardsModel

/// This protocol alllows us to create fake view models for testing the UI
public protocol RandomCardsProtocol: ObservableObject {

	var sortOrder: CardSortOrder { get set }
	
	var cards: [CreditCard] { get set }
	
	/// Not nil if an error occurs.
	var error: Error? { get }
	
	func refreshCards()
		
	func change(sortOrder: CardSortOrder)
}


public class RandomCardsViewModel: RandomCardsProtocol {
	
	public var sortOrder: CardSortOrder = .number
	
	@Published public var cards: [CreditCard] = []

	@Published public var error: Error?
		
	/// Listen for deleted cards
	private var deleteCardCancelable: AnyCancellable?
	
	public init() {
		registerForDeletes()
	}
	
	deinit {
		deregisterForDeletes()
	}
	
	/// Refresh cards off main thread in background.
	public func refreshCards() {
		Task {
			let session = URLSession.shared
			do {
				let cardsResult = try await RandomCardsAPI.getRandomCreditCards(session: session)
				switch cardsResult {
				case .success(let cards):
					await updateCards(cards: cards.sort(by: sortOrder))
				case .failure(let error):
					await update(error: error)
				}
			}
			catch {
				await update(error: error)
			}
		}
	}
	
	/// Update the sort order of the random cards
	/// - Parameter sortOrder: sort order to use
	public func change(sortOrder: CardSortOrder) {
		self.sortOrder = sortOrder
		
		// Update the card order on a background thread
		Task {
			await updateCards(cards: cards.sort(by: sortOrder))
		}
	}
	
	@MainActor
	/// Update the published property on the main actor
	/// The fact that this is on main actor means sort order change and refresh are thread safe.
	/// - Parameter cards: newly loaded cards from api call
	private func updateCards(cards: [CreditCard]) {
		self.cards = cards
	}
	
	@MainActor
	/// Update a specific card if e.g. saved status has changed forces a reload
	/// - Parameters:
	///   - index: of the card to update
	///   - card: the new card.
	private func updateCard(index: Int, card: CreditCard) {
		self.error = nil
		self.cards[index] = card // force a refresh.
	}
	
	@MainActor 
	/// Update error on main thread
	/// - Parameter error: error that occured.
	func update(error: Error) {
		self.error = error
	}

	/// Listen for deleted cards
	func registerForDeletes() {
		
		deleteCardCancelable = CreditCardViewModel.cardsDeletedSubject
			.receive(on: RunLoop.main)	// Ensure on main thread
			.dropFirst()				// Do not care about first value
			.sink { deletedIds in
				
				// we want the find to run on background thread.
				Task { [weak self] in
					await self?.updateCards(with: deletedIds)
				}
			}
	}
	
	/// Stop listening for detetes
	func deregisterForDeletes() {
		deleteCardCancelable?.cancel()
		deleteCardCancelable = nil
	}
	
	/// Check each deleted id and update card
	/// - Parameter deletedIds: deleted ids received
	private func updateCards(with deletedIds: [Int64]) async {
		for id in deletedIds {
			guard let (index, card) = self.card(with: Int(id)) else {
				continue
			}
			await self.updateCard(index: index, card: card)
		}
	}
		
	/// Find the card to update.
	/// - Parameter id: the unique id of card to search for
	/// - Returns: a tuple of index and card found otherwise nil
	private func card(with id: Int) -> (Int, CreditCard)? {
		if let card = cards.filter({ $0.id == id }).first,
		 let index = cards.firstIndex(of: card) {
			return (index, card)
		}
		return nil
	}
}

