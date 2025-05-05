//
//  TaskUserDefaults.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/06.
//

import Foundation
import UIKit

// UserDefaultsの保存あれこれを格納しているクラス
class TaskUserDefaults {
    // UserDefaultsのキー
    static let userDefaultsKey = "themeKeyColor"

    // UserDefaultsの保存
    static func saveThemeColor(type: ThemeColor) {
        UserDefaults.standard.setValue(type.rawValue, forKey: userDefaultsKey)
    }

    // UserDefaultsの取得
    static func getThemeColor() -> Int {
        return UserDefaults.standard.integer(
            forKey: "themeKeyColor")
    }
}
