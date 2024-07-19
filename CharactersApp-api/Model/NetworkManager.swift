//
//  NetworkManager.swift
//  CharactersApp-api
//
//  Created by Alex  on 18.07.2024.
//

import Foundation


class NetworkManager {
	
	static let shared = NetworkManager()

	private init() {}

	func fetchCharacters(page: Int, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
		let urlString = "https://rickandmortyapi.com/api/character?page=\(page)"
		guard let url = URL(string: urlString) else {
			completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}

		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
				return
			}

			do {
				let characterResponse = try JSONDecoder().decode(CharacterResponse.self, from: data)
				completion(.success(characterResponse))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}

	func fetchEpisode(url: String, completion: @escaping (Result<Episode, Error>) -> Void) {
		guard let url = URL(string: url) else {
			completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
			return
		}

		URLSession.shared.dataTask(with: url) { data, response, error in
			if let error = error {
				completion(.failure(error))
				return
			}

			guard let data = data else {
				completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
				return
			}

			do {
				let episode = try JSONDecoder().decode(Episode.self, from: data)
				completion(.success(episode))
			} catch {
				completion(.failure(error))
			}
		}.resume()
	}
}

