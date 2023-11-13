//
//  ContentView.swift
//  AGRandomCards
//
//  Created by Ant Gardiner on 8/11/23.
//

import SwiftUI
import CoreData
import RandomCardsViewModel

struct ContentView: View {
	@Environment(\.managedObjectContext) private var viewContext

	@State var randomCardsViewModel = RandomCardsViewModel()
	
	var body: some View {
		TabView {
			NavigationStack {
				RandomCardsView<RandomCardsViewModel>()
					.environment(\.managedObjectContext, viewContext)
					.environmentObject(randomCardsViewModel)
			}
			.tabItem {
				Label("Random Cards", systemImage: "creditcard")
			}
			NavigationStack {
				SavedCardsView()
					.environment(\.managedObjectContext, viewContext)
			}
			.tabItem {
				Label("Saved Cards", systemImage: "creditcard.and.123")
			}
			
		}
	}
}

#Preview {
	ContentView()
}
