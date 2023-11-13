//
//  RandomCardsView.swift
//  AGRandomCards
//
//  Created by Ant Gardiner on 9/11/23.
//

import SwiftUI
import RandomCardsAPI
import RandomCardsViewModel

struct RandomCardsView<ViewModel: RandomCardsProtocol>: View {
	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject private var randomCardsViewModel: ViewModel
	
	@State private var sortOrder: CardSortOrder = .number
	
	@State private var loaded = false
	
	var body: some View {
		NavigationStack {
			List {
				Section {
					ForEach(randomCardsViewModel.cards) { card in
						CreditCardView<CreditCardViewModel>()
							.environment(\.managedObjectContext, viewContext)
							.environmentObject(CreditCardViewModel(creditCard: card))
					}
				}
				if let error = randomCardsViewModel.error as? NetworkError {
					Text("\(error.errorDescription)")
				}
			}
		}
		.navigationBarTitle("Random Cards")
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Menu {
					Picker("Sort Order", selection: $sortOrder) {
						ForEach(CardSortOrder.allCases) { order in
							Text(order.title.capitalized)
						}
					}
					.onChange(of: sortOrder) { oldValue, newValue in
						randomCardsViewModel.change(sortOrder: newValue)
					}
				} label: {
					Image(systemName: "arrow.up.arrow.down")
				}
			}
		}
		.refreshable {
			randomCardsViewModel.refreshCards()
		}
		.onAppear {
			// Only load once.
			if !loaded {
				randomCardsViewModel.refreshCards()
				loaded.toggle()
			}
		}
	}
}

#Preview {
	NavigationStack {
		RandomCardsView<RandomCardsViewModel>()
			.environmentObject(RandomCardsViewModel())
	}
}
