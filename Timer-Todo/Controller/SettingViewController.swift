//
//  SettingViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/04.
//

import Foundation
import UIKit

class SettingViewController: UIViewController {
    let secationName = ["カスタマイズ", "その他"]
    let sectionData = [["テーマカラーの変更"], ["ご要望・ご意見"]]
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingViewController: UITableViewDataSource {
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return secationName.count
    }

    // セクションの中身
    func tableView(
        _ tableView: UITableView, titleForHeaderInSection section: Int
    ) -> String? {
        return secationName[section]
    }

    // セクションのセル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return sectionData[section].count
    }

    // セルのデータ
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SettingCell", for: indexPath)
        cell.textLabel?.text = sectionData[indexPath.section][indexPath.row]
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.textAlignment = .left
        return cell
    }

}

extension SettingViewController: UITableViewDelegate {
    // セルのタップ処理
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        // テーマカラーの変更がタップされたとき
        if indexPath.row == 0 {
            // alertの作成
            let defaultColor = UIAlertAction(
                title: "デフォルト", style: .default,
                handler: { _ -> Void in
                    self.setThemeColor(type: .default)
                })
            let blue = UIAlertAction(
                title: "ブルー", style: .default,
                handler: { _ -> Void in
                    self.setThemeColor(type: .blue)
                })
            let red = UIAlertAction(
                title: "レッド", style: .default,
                handler: { _ -> Void in
                    self.setThemeColor(type: .red)
                })

            let cancelColor = UIAlertAction(
                title: "キャンセル", style: .default,
                handler: nil)

            let alert = UIAlertController(
                title: "テーマカラーの選択", message: "", preferredStyle: .actionSheet)
            alert.addAction(defaultColor)
            alert.addAction(blue)
            alert.addAction(red)
            alert.addAction(cancelColor)
            present(alert, animated: true)

        } else if indexPath.row == 1 {
        }
    }

    // テーマの変更
    func setThemeColor(type: ThemeColor) {
        setTabTheme(type: type)
        setNavigationTheme(type: type)
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
        tabBarController?.tabBar.scrollEdgeAppearance = appearance
        tabBarController?.tabBar.standardAppearance = appearance

    }

    // ナビゲーションバーの色を変更する
    func setNavigationTheme(type: ThemeColor) {
        // ナビゲーションバーの背景色を変更
        navigationController?.navigationBar.scrollEdgeAppearance?
            .backgroundColor = type.color
    }

}
