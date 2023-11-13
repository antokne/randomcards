//
//  CreditCardView.swift
//  AGRandomCards
//
//  Created by Ant Gardiner on 10/11/23.
//

import SwiftUI
import RandomCardsAPI
import RandomCardsViewModel

struct CreditCardView<ViewModel: CreditCardProtocol>: View {
	
	@Environment(\.managedObjectContext) private var viewContext
	@EnvironmentObject private var creditCardViewModel: ViewModel

	var body: some View {
		VStack {
			HStack {
				Text(creditCardViewModel.number)
					.font(.title2.monospaced())
				Spacer()
				Button(action: { creditCardViewModel.toggleSave(context: viewContext) }, label: {
					Image(systemName: creditCardViewModel.saved ? "star.fill" : "star")
						.font(.title2)
				})
				.buttonStyle(.borderless) // The magic that makes this button work separately to a row in a list.
			}
			HStack {
				Text(creditCardViewModel.expiryDate)
				Spacer()
				Text(creditCardViewModel.type)
			}

				
		
		}
	}
}

#Preview {
	// Wrap in a list here as that is the intended use.
	List {
		CreditCardView<CreditCardViewModel>()
			.environmentObject(CreditCardViewModel(id: 2,
												   uid: "39873249837489",
												   number: "1234-1111-2222-3333",
												   expiryDate: "12-12-2025",
												   type: "visa",
												   saved: false))
	}
}
