import RealmSwift
import UIKit

class TaskViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate, UIAdaptivePresentationControllerDelegate
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

    // TodoデータをRealmから取得
    func getTaskData() {
        let realm = try! Realm()
        let result = realm.objects(Task.self)
        tasks = Array(result)
    }

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
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "TaskCellView", for: indexPath) as! TaskCell
        if task.isDone {
            // タスクは完了しているので、タスクに対して線を引いて完了にする
            cell.taskLabel?.attributedText = strikeThroughText(
                text: task.taskName)
            cell.timerLabel?.attributedText = strikeThroughText(
                text: task.formattedTime())

        } else {
            // タスク未完了の場合、普通に表示
            cell.taskLabel?.text = task.taskName
            cell.timerLabel?.text = task.formattedTime()
        }
        let uiImage = UIImage(systemName: tasks[indexPath.row].returnIconName())
        cell.cellLabel?.image = uiImage

        return cell
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
