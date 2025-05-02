import Foundation
import RealmSwift

class Task: Object, Codable {
    // タスクの一意に識別するためのID
    @objc dynamic var id: String = UUID().uuidString
    // タスク名
    @objc dynamic var taskName: String = ""
    // タスク時間
    // 秒で管理する
    @objc dynamic var taskTime: Int = 0
    // タスクの完了管理
    @objc dynamic var isDone: Bool = false
    
    @objc dynamic var deleteFlag: Bool = false
    
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
