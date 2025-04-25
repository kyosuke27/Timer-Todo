import UIKit

class TaskViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate,UIAdaptivePresentationControllerDelegate
{
    let userDefaults = UserDefaults.standard
    let jsonDecoder = JSONDecoder()

    @IBOutlet weak var tableView: UITableView!
    var task: [Task] = []
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
        getTodoData()
    }
    
    // モーダルのスワイプ削除とかでのイベント通知
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        getTodoData()
        tableView.reloadData()
    }
    
    // 再度タスク画面が表示された際に利用
    override func viewWillAppear(_ animated: Bool) {
        getTodoData()
        tableView.reloadData()
    }
    
    // TodoデータをUserDefaultsから取得
    func getTodoData() {
        // UserDefaultsから取得
        guard let data = userDefaults.data(forKey: "todo"),
            let taskArray = try? jsonDecoder.decode([Task].self, from: data)
        else {
            return
        }
        task =  taskArray

    }
    
    // UiTableViewSourceデリゲートで実装しなければならないもの
    // セルの個数を指定する部分
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return task.count
    }

    // セルに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(
                withIdentifier: "TaskCellView", for: indexPath) as! TaskCell
        cell.taskLabel?.text = task[indexPath.row].taskName
        cell.timerLabel?.text = task[indexPath.row].formattedTime()
        let uiImage = UIImage(systemName: task[indexPath.row].returnIconName())
        cell.cellLabel?.image = uiImage

        return cell
    }

    // セルタップ時の処理
    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        // タスクを完了にする
        task[indexPath.row].isDone = !task[indexPath.row].isDone
        // セルのリロード
        tableView.reloadData()
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
