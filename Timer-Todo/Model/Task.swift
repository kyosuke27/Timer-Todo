import Foundation

struct Task: Codable {
    // タスク名
    var taskName: String
    // タスク時間
    // 秒で管理する
    var taskTime: Int
    // タスクの完了管理
    var isDone: Bool

    // 秒を「00:00:00」へ変換する
    func formattedTime() -> String {
        var formattedString = ""
        let hour = String(format: "%02d", taskTime / 3600)
        let minutes = String(format: "%02d", (taskTime % 3600) / 60)
        let seconds = String(format: "%02d", taskTime % 60)
        formattedString = "\(hour):\(minutes):\(seconds)"
        return formattedString

    }

    func returnIconName() -> String {
        return isDone ? "checkmark.circle.fill" : "circle"
    }
}
