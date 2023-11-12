//
//  CardSortOrder.swift
//
//
//  Created by Ant Gardiner on 10/11/23.
//

import Foundation

public enum CardSortOrder: CaseIterable, Identifiable {
	case number
	case type
	
	public var id: Self { self }
	
	public var title: String {
		switch self {
		case .number:
			"Number"
		case .type:
			"Type"
		}
	}
}
