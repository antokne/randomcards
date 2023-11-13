// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

private let getRandomCardsUrlString = "https://random-data-api.com/api/v2/credit_cards" //?size=100

public enum NetworkError: Error {
	case invalidUrl
	case invalidResponse
	case serverError(statusCode: Int)
	case decodingError(Error)
	
	public var value: Int {
		switch self {
		case .serverError(let statusCode):
				return statusCode
		default:
			return 0
		}
	}
	
	public var errorDescription: String {
		switch self {
		case .invalidUrl:
			return "Invalid URL"
		case .invalidResponse:
			return "Invalid respoisne"
		case .serverError(let statusCode):
			return "Server error \(statusCode)"
		case .decodingError(let error):
			return "Failed to decode \(error.localizedDescription)"
		}
	}
}

// Create a session protocol used for testing.
public protocol URLSessionProtocol {
	func data( for request: URLRequest, delegate: (URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
}

// Ensure URLSession conforms
extension URLSession: URLSessionProtocol { }


/// API
public struct RandomCardsAPI {
	
	/// Get a list of random generated Credit Cards
	/// - Parameters:
	///   - session: the session to use
	///   - perPage: max number to return per page
	/// - Returns: A result that contains the credit cards or an Error.
	public static func getRandomCreditCards(session: URLSessionProtocol, perPage: Int = 100) async throws -> Result<[CreditCard], NetworkError> {
		
		var requestURL = URLComponents(string: getRandomCardsUrlString)! // safe here as a const.
		requestURL.queryItems = [
			URLQueryItem(name: "size", value: "\(perPage)")
		]
		
		// This will never happen as the url string is not invalid.
		guard let url = requestURL.url else {
			return .failure(NetworkError.invalidUrl)
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = "GET"
		
		let (data, response) = try await session.data(for: request, delegate: nil)
		
		guard let httpResponse = response as? HTTPURLResponse else {
			return .failure(NetworkError.invalidResponse)
		}
		
		// If not a success code then report error.
		guard (200...299).contains(httpResponse.statusCode) else {
			return .failure(NetworkError.serverError(statusCode: httpResponse.statusCode))
		}
		
		do {
			// Attempt to decode the json data into an array of CreditCards
			let decoder = JSONDecoder()
			decoder.keyDecodingStrategy = .convertFromSnakeCase
			let results = try decoder.decode([CreditCard].self, from: data)
			return .success(results)
		}
		catch {
			return .failure(NetworkError.decodingError(error))
		}
	}
	
}
