import RealmSwift
import UIKit

class TaskViewController: UIViewController,
    UIAdaptivePresentationControllerDelegate
{
    let userDefaults = UserDefaults.standard
    let jsonDecoder = JSONDecoder()

    @IBOutlet weak var tableView: UITableView!
    var tasks: [Task] = []
    // 画面が作成される際に一度だけ
    override func viewDidLoad() {
        tableView.register(
            UINib(nibName: "TaskCellView", bundle: nil),
            forCellReuseIdentifier: "TaskCellView")

        // tableViewのセルの高さを変更
        self.tableView.rowHeight = 60
        // todoデータの取得
        // UserDefaultsから取得
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        // Realmからデータの取得
        getTaskData()

    }

    // モーダルのスワイプ削除とかでのイベント通知
    func presentationControllerDidDismiss(
        _ presentationController: UIPresentationController
    ) {
        getTaskData()
        tableView.reloadData()
    }

    // 再度タスク画面が表示された際に利用
    override func viewWillAppear(_ animated: Bool) {
        getTaskData()
        tableView.reloadData()
    }

    // attributeText
    func strikeThroughText(text: String) -> NSAttributedString {
        let attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .strikethroughColor: UIColor.black,  // 線の色
        ]
        return NSAttributedString(
            string: text, attributes: attributes)

    }

    @IBAction func addTaskAction(_ sender: UIButton) {
        // モーダルを表示する処理
        // StoryBoardを取得
        // 別のStoryBoardファイルを使用するので、名前を指定して作成する。
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        // AddTaskViewControllerのインスタンスを取得
        // Viewcontrollerの取得
        // StoryBoardのIdentifierで設定した名前を記載する
        guard
            let addTaskViewController = storyboard.instantiateViewController(
                withIdentifier: "AddTask") as? AddTaskViewController
        else {
            return
        }
        addTaskViewController.presentationController?.delegate = self
        // モーダルの表示
        self.present(addTaskViewController, animated: true)

    }

}

// MARK: - Realm関係
extension TaskViewController {
    // realm関係
    // Todoデータ取得
    // deleteFlagがtrueのものは除外する
    func getTaskData() {
        let realm = try! Realm()
        // 当日の日付
        let now = Date()
        let startDay = Calendar.current.startOfDay(for: now)

        // 翌日の00:00:00
        guard let endDay = Calendar.current.date(
            byAdding: .day, value: 1, to: startDay)
        else {
            return
        }
        // 一旦全部出力
        let result1 = realm.objects(Task.self)
        // 登録日付を本日かつ、論理削除false
        let result = realm.objects(Task.self).filter(
            "registerDate >= %@ AND registerDate < %@ AND deleteFlag == false",
            startDay, endDay
        ).map {
            $0
        }
        tasks = Array(result)
    }

    // 削除処理
    func deleteTask(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            // 論理削除
            task.deleteFlag = true
        }
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    // セルのスライド削除機能をつける
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        // 削除スワイプ処理
        let deleteAction = UIContextualAction(style: .normal, title: "削除") {
            (action, view, completionHandler) in
            // 論理削除処理
            self.deleteTask(indexPath: indexPath)
            completionHandler(true)
        }
        // ボタンの色を設定
        deleteAction.backgroundColor = .red
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    // セルタップ時の処理
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        let task = tasks[indexPath.row]
        if !task.isDone {
            // タスクの詳細画面に遷移する
            let storyboard = UIStoryboard(name: "Task", bundle: nil)
            let taskDetailViewController =
                storyboard.instantiateViewController(
                    withIdentifier: "TaskDetailViewController")
                as! TaskDetailViewController
            taskDetailViewController.configure(task: tasks[indexPath.row])
            tableView.deselectRow(at: indexPath, animated: true)
            // 遷移処理
            navigationController?.pushViewController(
                taskDetailViewController, animated: true)
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension TaskViewController: UITableViewDataSource {
    // UiTableViewSourceデリゲートで実装しなければならないもの
    // セルの個数を指定する部分
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return tasks.count
    }

    // セルに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let task = tasks[indexPath.row]
        var uiImage = UIImage(systemName: task.returnIconName())
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "TaskCellView", for: indexPath) as! TaskCell
        if task.isDone {
            // タスクは完了しているので、タスクに対して線を引いて完了にする
            cell.taskLabel?.attributedText = strikeThroughText(
                text: task.taskName)
            cell.timerLabel?.attributedText = strikeThroughText(
                text: task.formattedTime())
            uiImage = UIImage(
                systemName: tasks[indexPath.row].returnIconName())

        } else {
            // タスク未完了の場合、普通に表示
            cell.taskLabel?.text = task.taskName
            cell.timerLabel?.text = task.formattedTime()
        }
        cell.cellLabel?.image = uiImage
        return cell
    }
}
