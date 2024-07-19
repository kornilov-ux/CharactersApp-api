//
//  CharacterModel.swift
//  CharactersApp-api
//
//  Created by Alex  on 18.07.2024.
//

import Foundation

struct CharacterResponse: Codable {
	let info: Info
	let results: [Character]
}

struct Info: Codable {
	let count: Int
	let pages: Int
	let next: String?
	let prev: String?
}

struct Character: Codable {
	let id: Int
	let name: String // имя
	let status: String // живой-не живой-неизвестно
	let species: String // расса
	let type: String 
	let gender: String // гендер
	let origin: Location 
	let location: Location // Last known location
	let image: String
	let episode: [String] // 
	let url: String
	let created: String
}

struct Location: Codable {
	let name: String  // имя планеты (Last known location)
	let url: String
}

