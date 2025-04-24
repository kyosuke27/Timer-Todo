//
//  TaskViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/23.
//
import UIKit

class TaskViewController: UIViewController, UITableViewDataSource,
    UITableViewDelegate
{
    @IBOutlet weak var tableView: UITableView!
    let todo = ["何かする","勉強","買い物","掃除"]
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "TaskCellView", bundle: nil), forCellReuseIdentifier: "TaskCellView")

        // tableViewのセルの高さを変更
        self.tableView.rowHeight = 60
    }
    

    // UiTableViewSourceデリゲートで実装しなければならないもの
    // セルの個数を指定する部分
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return todo.count
    }

    // セルに値を設定する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCellView", for: indexPath) as! TaskCell
        cell.taskLabel?.text = todo[indexPath.row]
        cell.timerLabel?.text = "00:00:00"
        return cell
    }
    
    // セルタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    
    @IBAction func addTaskAction(_ sender: UIButton) {
        // モーダルを表示する処理
        // StoryBoardを取得
        // 別のStoryBoardファイルを使用するので、名前を指定して作成する。
        let storyboard = UIStoryboard(name: "AddTask", bundle: nil)
        // AddTaskViewControllerのインスタンスを取得
        // Viewcontrollerの取得
        // StoryBoardのIdentifierで設定した名前を記載する
        guard let addTaskViewController = storyboard.instantiateViewController(withIdentifier: "AddTask") as? AddTaskViewController else {
            return
        }
        // モーダルの表示
        self.present(addTaskViewController, animated: true)
        
    }
    
}
