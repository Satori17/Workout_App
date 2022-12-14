//
//  DisplayableModel.swift
//  Workout_App
//
//  Created by Saba Khitaridze on 05.09.22.
//

import UIKit

protocol Displayable {
    var id: Int  { get set }
    var name: String { get set }
    var description: String { get set }
    var category: CategoryDisplayable { get set }
    var muscles: [MuscleDisplayable] { get set }
    var musclesSecondary: [MuscleDisplayable] { get set }
    var equipment: [EquipmentDisplayable] { get set }
    var language: LanguageDisplayable { get set }
    var license: LicenseDisplayable { get set }
    var licenseAuthor: String { get set }
    var images: [ImageDisplayable] { get set }
    var comments: [CommentDisplayable] { get set }
    var variations: [Displayable] { get set }
    var isMissed: Bool { get set }
}

extension Displayable {
    
    var license: LicenseDisplayable {
        get {
            LicenseDisplayable()
        }
        set {}
    }
    
    var licenseAuthor: String {
        get {
            CustomTitle.empty
        }
        set {}
    }
    
    var variations: [Displayable] {
        get {
            []
        }
        set {}
    }
    
    var isMissed: Bool {
        get {
            false
        }
        set {}
    }
}

//MARK: - Category
struct CategoryDisplayable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        id = 0
        name = CategoryError.name
    }
}

//MARK: - Muscle
struct MuscleDisplayable {
    let name: String
    let isFront: Bool
    let imageUrlMain, imageUrlSecondary: String
}

//MARK: - Equipment
struct EquipmentDisplayable {
    let id: Int
    let name: String
}

//MARK: - Language
struct LanguageDisplayable {
    let id: Int
    let shortName, fullName: String
    
    init(id: Int, shortName: String, fullName: String) {
        self.id = id
        self.shortName = shortName
        self.fullName = fullName
    }
    
    init() {
        id = 0
        shortName = LanguageError.shortName
        fullName = LanguageError.fullName
    }
}

//MARK: - License
struct LicenseDisplayable {
    let licenseInfo: LanguageDisplayable
    let url: URL
    
    init(licenseInfo: LanguageDisplayable, url: URL) {
        self.licenseInfo = licenseInfo
        self.url = url
    }
    
    init() {
        let defaultUrlString = BaseUrl.licensePlaceholderUrl.rawValue
        licenseInfo = LanguageDisplayable()
        url = URL(string: defaultUrlString) ?? URL(fileURLWithPath: CustomTitle.empty)
    }
}

//MARK: - Image
struct ImageDisplayable {
    let id: Int
    let image: String
    let isMain: Bool
}

//MARK: - Comment
struct CommentDisplayable {
    let id, exercise: Int
    let comment: String
}
