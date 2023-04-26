//
//  MovieService.swift
//  Lab 3
//
//  Created by Luis Ligunas on 4/26/23.
//

import Foundation

class MovieService {
	func searchMovies(query: String, completion: @escaping (SearchResponse?) -> Void) {
		guard let baseURL = URL(string: "https://www.omdbapi.com") else { return }

		var url = baseURL
		url.append(queryItems: [
			URLQueryItem(name: "apikey", value: "afd88f51"),
			URLQueryItem(name: "s", value: query)
		])

		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = "get"
		let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
			var searchResponse: SearchResponse?
			defer { completion(searchResponse) }
			guard error == nil,
				  let httpResponse = response as? HTTPURLResponse,
				  (200...299).contains(httpResponse.statusCode),
				  let data = data,
				  let response = try? JSONDecoder().decode(SearchResponse.self, from: data)
			else { return }
			searchResponse = response
		}
		task.resume()

	}
}
