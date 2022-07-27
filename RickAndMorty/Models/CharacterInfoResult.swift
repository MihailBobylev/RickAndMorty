//
//  CharacterInfoResult.swift
//  RickAndMorty
//
//  Created by Mikhail on 26.07.2022.
//

import Foundation

struct CharacterInfoResult: Codable {
    let info: Info
    let results: [RaMCharacter]
}

struct RaMCharacter: Codable {
    let name: String
    let image: String
}

struct Info: Codable {
    var next: String?
}
