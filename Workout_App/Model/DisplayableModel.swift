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
            ""
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

//category
struct CategoryDisplayable {
    let id: Int
    let name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    init() {
        id = 0
        name = "error getting category name"
    }
}

//muscle
struct MuscleDisplayable {
    let name: String
    let isFront: Bool
    let imageUrlMain, imageUrlSecondary: String
}

//equipment
struct EquipmentDisplayable {
    let id: Int
    let name: String
}

//language
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
        shortName = "error getting shortName"
        fullName = "error getting fullName"
    }
}

//license
struct LicenseDisplayable {
    let licenseInfo: LanguageDisplayable
    let url: URL
    
    init(licenseInfo: LanguageDisplayable, url: URL) {
        self.licenseInfo = licenseInfo
        self.url = url
    }
    
    init() {
        let defaultUrlString = "https://via.placeholder.com/600x400?text=Error+Getting+License"
        licenseInfo = LanguageDisplayable()
        url = URL(string: defaultUrlString) ?? URL(fileURLWithPath: "")
    }
}

//image
struct ImageDisplayable {
    let id: Int
    let image: String
    let isMain: Bool
}

//comment
struct CommentDisplayable {
    let id, exercise: Int
    let comment: String
}
