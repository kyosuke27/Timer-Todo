//
//  TimerViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/23.
//

import UIKit

class TimerViewController: UIViewController{
    @IBOutlet weak var timerText: UILabel!
    var timer:Timer!
    var date:Date!
    
    override func viewDidLoad() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func updateTimer(){
        date = Date()
        timerText.text = String(
            format: "%02d:%02d:%02d",
            Calendar.current.component(.hour, from: date),
            Calendar.current.component(.minute, from: date),
            Calendar.current.component(.second, from: date))
    }
}
