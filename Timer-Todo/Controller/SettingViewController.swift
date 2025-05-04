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
        print("cellForRowAt")
        print("indexPath.section: \(indexPath.section)")
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
                    print("selected defalut color")
                })
            let blue = UIAlertAction(
                title: "ブルー", style: .default,
                handler: { _ -> Void in
                    print("selected blue color")
                })

            let cancelColor = UIAlertAction(
                title: "キャンセル", style: .default,
                handler: nil)

            let alert = UIAlertController(
                title: "テーマカラーの選択", message: "", preferredStyle: .actionSheet)
            alert.addAction(defaultColor)
            alert.addAction(cancelColor)
            present(alert, animated: true)

        } else if indexPath.row == 1 {
        }
    }
}
