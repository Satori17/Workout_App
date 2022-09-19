//
//  WorkoutModel.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 24.07.22.
//

import Foundation

// MARK: - Workout
struct Workout: Decodable {
    let id: Int?
    let name: String?
    let resultDescription: String?
    let category: Category?
    let muscles, musclesSecondary: [Muscle]?
    let equipment: [Category]?
    let language: Language?
    let license: License?
    let licenseAuthor: String?
    let images: [Image]?
    let comments: [Comment]?
    let variations: [Int]?

    enum CodingKeys: String, CodingKey {
        case id, name
        case resultDescription = "description"
        case category, muscles
        case musclesSecondary = "muscles_secondary"
        case equipment, language, license
        case licenseAuthor = "license_author"
        case images, comments, variations
    }
}

// MARK: - Category
struct Category: Decodable {
    let id: Int?
    let name: String?
}

// MARK: - Language
struct Language: Decodable {
    let id: Int?
    let shortName, fullName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
    }
}

//MARK: - License
struct License: Decodable {
    let id: Int?
    let shortName, fullName: String?
    let url: URL?
    
    enum CodingKeys: String, CodingKey {
        case id
        case shortName = "short_name"
        case fullName = "full_name"
        case url
    }
}

// MARK: - Muscle
struct Muscle: Decodable {
    let id: Int?
    let name: String?
    let isFront: Bool?
    let imageURLMain, imageURLSecondary: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case isFront = "is_front"
        case imageURLMain = "image_url_main"
        case imageURLSecondary = "image_url_secondary"
    }
}

// MARK: - Image
struct Image: Decodable {
    let id: Int?
    let image: String?
    let isMain: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case isMain = "is_main"
    }
}

// MARK: - Comment
struct Comment: Decodable {
    let id, exercise: Int?
    let comment: String?
}
