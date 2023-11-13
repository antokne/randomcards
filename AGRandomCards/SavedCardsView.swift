//
//  SavedCardsView.swift
//  AGRandomCards
//
//  Created by Ant Gardiner on 9/11/23.
//

import SwiftUI
import RandomCardsModel
import RandomCardsViewModel

struct SavedCardsView: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	
	@FetchRequest(fetchRequest: SavedCreditCard.sortedFetchRequest(), animation: .default)
	private var cards: FetchedResults<SavedCreditCard>
	
	var body: some View {
		NavigationStack {
			List {
				ForEach(cards) { card in
					CreditCardView<CreditCardViewModel>()
						.environment(\.managedObjectContext, viewContext)
						.environmentObject(CreditCardViewModel(savedCreditCard: card))
				}
				.onDelete(perform: deleteItems)

				
			}
			.navigationBarTitle("Saved Cards")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					EditButton()
				}
			}
		}
	}
		
	private func deleteItems(offsets: IndexSet) {
		withAnimation {
			let cardModels: [CreditCardViewModel] = offsets.map { CreditCardViewModel(savedCreditCard: cards[$0]) }
			for cardModel in cardModels {
				try? cardModel.delete(context: viewContext)
			}
		}
	}
}

#Preview {
	SavedCardsView()
}
