//
//  TimerViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/23.
//

import UIKit

class TimerViewController: UIViewController {
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var timerDate: UILabel!
    var timer: Timer!
    var date: Date!

    override func viewDidLoad() {
        let date = Date()
        timerDate.text = TimerUtil.convertDateToDisplayFormat(date: date)
        // タイマーの初期化
        timerText.text = TimerUtil.convertDateToTimerDisplayFormat(date: date)
        // タイマーの設定
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }

    @objc func updateTimer() {
        date = Date()
        timerText.text = TimerUtil.convertDateToTimerDisplayFormat(date: date)
    }
    // 画面を離れる際にTimerを破棄
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    // 画面を戻る際にTimerを再設定
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // タイマーの設定
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
}
