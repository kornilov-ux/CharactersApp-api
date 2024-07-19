//
//  EpisodeModel.swift
//  CharactersApp-api
//
//  Created by Alex  on 18.07.2024.
//

import Foundation

struct Episode: Codable {
	let id: Int
	let name: String // здесь мне нужно только имя эпизода, чтобы отображалось имя эпизода, а не id эпизода 
	let air_date: String
	let episode: String
	let characters: [String]
	let url: String
	let created: String
}
