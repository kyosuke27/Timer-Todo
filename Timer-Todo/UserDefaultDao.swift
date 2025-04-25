import Foundation

class UserDefaultDao {
    static let userDefaults = UserDefaults.standard
    static let jsonDecoder = JSONDecoder()
    // Taskデータの保存
    // クラスメソッドに設定
    static func saveTaskData(task: String) {
        // UserDefaultsに保存する

    }

    static func getTaskData(task: String) {
        
    }

}
