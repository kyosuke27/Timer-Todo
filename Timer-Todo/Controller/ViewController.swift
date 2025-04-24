//
//  ViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/22.
//

import KDCircularProgress
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var progress: KDCircularProgress!
    var date: Date!
    var clock: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // ラベルの大きさを文字の大きさに設定
        timeLabel.adjustsFontSizeToFitWidth = true
        
        // progressTimerの設定
//        progress = KDCircularProgress(
//            frame: CGRect(
//                x: 0,
//                y: 0, width: 300, height: 300))
//        progress.startAngle = -90
//        progress.progressThickness = 0.2
//        progress.trackThickness = 0.6
//        progress.clockwise = true
//        progress.gradientRotateSpeed = 2
//        progress.roundedCorners = false
//        progress.glowMode = .forward
//        progress.glowAmount = 0.9
//        progress.set(colors: UIColor.cyan)
//        progress.center = CGPoint(x: view.center.x, y: view.center.y + 25)
//        view.addSubview(progress)
//        progress.animate(
//            fromAngle: 0, toAngle: 360, duration: 10, completion: nil)
        
        // 現在時刻の取得
        clock = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateData),
            userInfo: nil,
            repeats: true)
    }
    @objc func updateData() {
        date = Date()
        timeLabel.text = String(
            format: "%02d:%02d:%02d",
            Calendar.current.component(.hour, from: date),
            Calendar.current.component(.minute, from: date),
            Calendar.current.component(.second, from: date))

    }

}
