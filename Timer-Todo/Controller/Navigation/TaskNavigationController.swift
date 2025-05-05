//
//  TaskNavigationController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/06.
//

import Foundation
import UIKit

class TaskNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func setNavigationTheme(type: ThemeColor) {
        // ナビゲーションバーの背景色を変更
        navigationBar.scrollEdgeAppearance?
            .backgroundColor = type.color
    }

    override func viewWillAppear(_ animated: Bool) {
        let themeColorType = TaskUserDefaults.getThemeColor()
        let themeColor = ThemeColor(rawValue: themeColorType) ?? .default
        setNavigationTheme(type: themeColor)

    }
}
