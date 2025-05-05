//.
//  TaskDetailViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/29.
//

import Foundation
import KDCircularProgress
import RealmSwift
import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var progressBar: KDCircularProgress!
    var task: Task!
    var timer: Timer?
    // 残り時間
    var remainingTime: Int = 0
    var previousProgressAmout = 360.0
    override func viewDidLoad() {
        taskLabel.text = task.taskName
        remainingTime = task.taskTime
        timerLabel.text = TimerUtil.convertTimerToFormatString(
            timeSeconds: remainingTime)
        setProgressBarOption()
    }

    func setProgressBarOption() {
        progressBar.trackThickness = 0.5
        progressBar.progressThickness = 0.5
        progressBar.glowMode = .constant
    }
    @IBAction func StartButtonAction(_ sender: UIButton) {
        if remainingTime > 0 {
            // タイマーが起動している場合には停止する
            // 条件：タイマーが起動している
            if timer?.isValid ?? false {
                timer?.invalidate()
                timerButton.setTitle("スタート", for: .normal)
                updateTask(totalTime: remainingTime, isDone: false)
            } else {
                // Timerの減少スタート
                timer = Timer.scheduledTimer(
                    timeInterval: 1,
                    target: self,
                    selector: #selector(decreaseTimer),
                    userInfo: nil,
                    repeats: true)
                timerButton.setTitle("ストップ", for: .normal)

            }
        } else {
            // タスク完了ボタンの際の処理
            // タスクの完了フラグの更新
            self.dismiss(animated: true, completion: nil)
        }
    }

    // タイマーの減少とプログレスバーの変更
    @objc func decreaseTimer() {
        // Timerの減少
        remainingTime -= 1
        if remainingTime <= 0 {
            // タスクの完了処理を行う
            timerButton.setTitle("タスク完了", for: .normal)
            timer?.invalidate()
            remainingTime = 0
            progressBar.animate(
                fromAngle: progressBar.angle,
                toAngle: 0,
                duration: 0,
                completion: nil)
            // remainingTimeは0を想定する
            updateTask(totalTime: remainingTime, isDone: true)
            // タスクの完了ポップアップを出す
            let storyboard = UIStoryboard(name: "Task", bundle: nil)
            let popupView: PopupViewController =
                storyboard.instantiateViewController(
                    identifier: "PopupViewController") as! PopupViewController
            popupView.modalPresentationStyle = .overFullScreen
            popupView.modalTransitionStyle = .crossDissolve
            self.present(popupView, animated: true, completion: nil)
            // 残り時間が0以下になった際にはプログレスバーの減少処理を行わない
        } else {
            updateProgressBar()
        }
        timerLabel.text = TimerUtil.convertTimerToFormatString(
            timeSeconds: remainingTime)
    }

    func updateProgressBar() {
        let ratio = Double(remainingTime - 1) / Double(task.taskTime)
        // アニメーションをしながら減少
        progressBar.animate(
            fromAngle: previousProgressAmout,
            toAngle: 360 * ratio,
            duration: 1.0,
            completion: nil)
        previousProgressAmout = 360 * ratio

    }

    func configure(task: Task) {
        self.task = task
    }
}

// MARK: - Realm
extension TaskDetailViewController {
    func updateTask(totalTime: Int, isDone: Bool) {
        // realmへのデータ登録
        let realm = try! Realm()
        try! realm.write {
            task.taskTime = totalTime
            task.isDone = isDone
            realm.add(task)
        }
    }
}
