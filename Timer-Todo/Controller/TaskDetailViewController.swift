//.
//  TaskDetailViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/29.
//

import Foundation
import KDCircularProgress
import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var progressBar: KDCircularProgress!
    var task: Task!
    var timer: Timer?
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
        if timer?.isValid ?? false {
            timer?.invalidate()
            timerButton.setTitle("スタート", for: .normal)
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
    }

    // タイマーの減少とプログレスバーの変更
    @objc func decreaseTimer() {
        // Timerの減少
        remainingTime -= 1
        if remainingTime <= 0 {
            timer?.invalidate()
            remainingTime = 0
        }
        timerLabel.text = TimerUtil.convertTimerToFormatString(
            timeSeconds: remainingTime)
        updateProgressBar()
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
