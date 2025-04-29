//
//  Timer.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/29.
//

import Foundation

class TimerUtil {
    // 秒数をHH:MM:SS形式の文字列に変換する
    static func convertTimerToFormatString(timeSeconds: Int) -> String {
        var formattedString = ""
        let hour = String(format: "%02d", timeSeconds / 3600)
        let minutes = String(format: "%02d", (timeSeconds % 3600) / 60)
        let seconds = String(format: "%02d", timeSeconds % 60)
        formattedString = "\(hour):\(minutes):\(seconds)"
        return formattedString
    }
}
