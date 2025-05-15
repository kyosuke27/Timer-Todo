//
//  ColorTableViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/14.
//

import Foundation
import UIKit

class ColorTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var colorTypeArray = [
        ThemeColor.default,
        ThemeColor.red,
        ThemeColor.blue,
        ThemeColor.green,
        ThemeColor.purple,
        ThemeColor.pink
    ]
    override func viewDidLoad() {
        tableView.estimatedRowHeight = 100
        // nibNameはファイル名,forCellReuseIdenfifierはxibファイルで指定した名前
        tableView.register(
            UINib(nibName: "ColorCell", bundle: nil),
            forCellReuseIdentifier: "ColorCellController")
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ColorTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return colorTypeArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "ColorCellController", for: indexPath)
            as! ColorCellController
        let colorType = colorTypeArray[indexPath.row]
        // colorTypeでCellのLabelの文字を変更
        switch colorType {
        case .default:
            cell.colorLabel?.text = "デフォルト"
            cell.ColorView?.isHidden = true
        case .red:
            cell.colorLabel?.text = "レッド"
        case .blue:
            cell.colorLabel?.text = "ブルー"
        case .green:
            cell.colorLabel?.text = "グリーン"
        case .purple:
            cell.colorLabel?.text = "パープル"
        case .pink:
            cell.colorLabel?.text = "ピンク"
        }
        cell.ColorView?.backgroundColor = colorType.color
        return cell
    }

}

extension ColorTableViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        // 選択された行の色を取得
        let selectedColor = colorTypeArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        setThemeColor(type: selectedColor)
    }
    // テーマの変更
    func setThemeColor(type: ThemeColor) {
        // タブバーのコントローラーを取得してテーマカラーの変更を行う
        if let myTab = self.tabBarController as? TaskTabController {
            myTab.setThemeColor(type: type)
        }
        // ナビゲーションバーの背景色を変更
        if let navigationBar = self.navigationController
            as? TaskNavigationController
        {
            navigationBar.setNavigationTheme(type: type)
        }
        // UserDefaultsにテーマカラーを保存
        TaskUserDefaults.saveThemeColor(type: type)
    }
}
