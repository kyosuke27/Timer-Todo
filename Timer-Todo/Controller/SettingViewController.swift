//
//  SettingViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/05/04.
//

import Foundation
import MessageUI
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
        if indexPath.row == 0 && indexPath.section == 0 {
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
            // --- ポップオーバー用の表示元を指定 ---
            if let pop = alert.popoverPresentationController {
                pop.sourceView = self.view  // 親ビュー
                pop.sourceRect = CGRect(
                    x: self.view.bounds.midX,
                    y: self.view.bounds.midY,
                    width: 0, height: 0
                )  // タップ位置や中心など、お好みで
                pop.permittedArrowDirections = []  // 矢印を不要にするなら
            }
            alert.addAction(defaultColor)
            alert.addAction(blue)
            alert.addAction(red)
            alert.addAction(cancelColor)
            present(alert, animated: true)

        } else if indexPath.row == 0 && indexPath.section == 1 {
            // お問い合わせメール
            sendMail()
        }
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

// MARK: - MFMailComposeViewController
extension SettingViewController: MFMailComposeViewControllerDelegate {
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            // 宛先
            mail.setToRecipients(["happydevalone@gmail.com"])
            // 件名
            mail.setSubject("お問い合わせ")
            present(mail, animated: true, completion: nil)
        } else {
            print("メールが送信できません")
        }
    }

    // MFMaoilComposeViewControllerDelegateのデリゲートメソッド
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult, error: (any Error)?
    ) {
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        switch result {
        case .cancelled:
            print("メール送信キャンセル")
        case .saved:
            print("メール送信保存")
        case .sent:
            print("メール送信完了")
        default:
            print("メール送信失敗")
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
