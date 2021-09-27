//
//  Created by Denis Mikhaylovskiy on 05/11/2020.
//
import Foundation
/// Модель данных, описывающая константы приложения
struct loginModel: UniqueIdentifiable, Codable {
    
    let uid: UniqueIdentifier = UUID().uuidString
    let urlList: [String]
    let mainDomain: String
    let apiURL: String
    let tabBarTitles: [String:[String]]
    let tabBarTintColor: String
    let tabBarKeywords : [String]
    let tabBarImagesNormal: [String]
    let tabBarImagesActive: [String]
    let primarySplashImage: String
    let secondarySplashImage: String
    let secondarySplashTabs: [Int]
    let activityIndicatorEnabledOnTabs: [Int]
    let hudTitle: String
    let primaryHudColor: String
    let secondaryHudColor: String
    let allowedURLs: [String]
    let pushAppID: Int
    let tabBarTitlesDefault: [String]
    let app2web: Int
}

extension loginModel: Equatable {
    static func == (lhs: loginModel, rhs: loginModel) -> Bool {
        return lhs.uid == rhs.uid
    }
}
