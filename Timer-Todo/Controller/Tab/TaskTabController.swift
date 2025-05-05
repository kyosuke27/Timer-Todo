//
//  TaskTabController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/05.
//

import Foundation
import UIKit

class TaskTabController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initTab()
    }

    func initTab() {
        print("initTab")
        let themeColorType = UserDefaults.standard.integer(
            forKey: "themeKeyColor")
        let themeColor = ThemeColor(rawValue: themeColorType) ?? .default
        print(themeColor)
        setThemeColor(type: themeColor)
    }

    // テーマの変更
    func setThemeColor(type: ThemeColor) {
        setTabTheme(type: type)
        saveThemeColor(type: type)
    }

    // タブバーの色を変更する
    func setTabTheme(type: ThemeColor) {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = type.color
        // icon色の変更を行う
        let isDefault = type == .default
        let unselectedColor: UIColor = isDefault ? .gray : .white
        appearance.stackedLayoutAppearance.normal.iconColor = unselectedColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: unselectedColor
        ]
        // タブバーの色を変更する
        tabBar.scrollEdgeAppearance = appearance
        tabBar.standardAppearance = appearance

    }
    func saveThemeColor(type: ThemeColor) {
        UserDefaults.standard.setValue(type.rawValue, forKey: "themeKeyColor")
    }
}
