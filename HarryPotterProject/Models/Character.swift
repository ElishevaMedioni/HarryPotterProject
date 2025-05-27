//
//  Character.swift
//  HarryPotterProject
//
//  Created by Elisheva Medioni on 15/05/2025.
//

import Foundation

struct Character: Codable, Identifiable {
    var id: String { nickname }
    let fullName, nickname: String
    let hogwartsHouse: HogwartsHouse
    let interpretedBy: String
    let children: [String]
    let image: String
    let birthdate: String
    let index: Int
    
    // we need a coding key because I added id that is not in the json structure
    enum CodingKeys: String, CodingKey {
            case fullName, nickname, hogwartsHouse, interpretedBy, children, image, birthdate, index
        }
}

enum HogwartsHouse: String, Codable {
    case gryffindor = "Gryffindor"
    case hufflepuff = "Hufflepuff"
    case ravenclaw = "Ravenclaw"
    case slytherin = "Slytherin"
}
