import FSCalendar
import RealmSwift
import StoreKit
import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{
    let userDefault = UserDefaults.standard
    let jsonDecoder = JSONDecoder()
    @IBOutlet weak var timerPickerView: UIPickerView!
    @IBOutlet weak var taskText: UITextField!

    let hourArray = Array(0...23)
    let minuteArray = Array(0...59)
    let secondArray = Array(0...59)

    let dataList = [Array(0...23), Array(0...59), Array(0...59)]
    override func viewDidLoad() {
        timerPickerView.delegate = self
        timerPickerView.dataSource = self
        // timerPickerのラベルを作成
        // 時間ラベル作成
        let hourLabel = UILabel()
        hourLabel.text = "時間"
        hourLabel.sizeToFit()
        hourLabel.frame = CGRectMake(
            timerPickerView.bounds.width / 4 - hourLabel.bounds.width / 2,
            timerPickerView.bounds.height / 2 - (hourLabel.bounds.height / 2),
            hourLabel.bounds.width, hourLabel.bounds.height)
        timerPickerView.addSubview(hourLabel)
        // 分ラベル作成
        let minuteLabel = UILabel()
        minuteLabel.text = "分"
        minuteLabel.sizeToFit()
        minuteLabel.frame = CGRectMake(
            timerPickerView.bounds.width / 2 - minuteLabel.bounds.width / 2,
            timerPickerView.bounds.height / 2 - (minuteLabel.bounds.height / 2),
            minuteLabel.bounds.width, minuteLabel.bounds.height)
        timerPickerView.addSubview(minuteLabel)
        // 秒ラベル作成
        let secondLabel = UILabel()
        secondLabel.text = "秒"
        secondLabel.sizeToFit()
        secondLabel.frame = CGRectMake(
            timerPickerView.bounds.width * 3 / 4 - secondLabel.bounds.width
                / 2,
            timerPickerView.bounds.height / 2 - (secondLabel.bounds.height / 2),
            secondLabel.bounds.width, secondLabel.bounds.height)
        timerPickerView.addSubview(secondLabel)
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

    }

    @IBAction func tapXmark(_ sender: UIButton) {
        // モーダルを閉じる
        self.dismiss(animated: true, completion: nil)

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return dataList.count
    }

    func pickerView(
        _ pickerView: UIPickerView, numberOfRowsInComponent component: Int
    ) -> Int {
        return dataList[component].count
    }

    // Pickerの大きさを設定
    func pickerView(
        _ pickerView: UIPickerView, widthForComponent component: Int
    ) -> CGFloat {
        return timerPickerView.bounds.width * 1 / 4
    }

    func pickerView(
        _ pickerView: UIPickerView, viewForRow row: Int,
        forComponent component: Int, reusing view: UIView?
    ) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = .left
        pickerLabel.text = String(dataList[component][row])
        return pickerLabel

    }

    @IBAction func registerTaskAction(_ sender: UIButton) {
        // Timerの値

        // 時・分・秒を全て足して秒に変換
        let hour = self.hourArray[timerPickerView.selectedRow(inComponent: 0)]
        let minute = self.minuteArray[
            timerPickerView.selectedRow(inComponent: 1)]
        let second = self.secondArray[
            timerPickerView.selectedRow(inComponent: 2)]
        let totalSecond = hour * 3600 + minute * 60 + second
        let taskText = self.taskText.text ?? ""
        // realmへ保存する
        saveTaskData(taskText: taskText, totalSecond: totalSecond)
        checkRequestReview()
        // モーダルを閉じる
        self.dismiss(animated: true, completion: nil)
        guard let presentationController = presentationController else {
            return
        }
        presentationController.delegate?.presentationControllerDidDismiss?(
            presentationController)
    }

    // Realmへデータの登録
    func saveTaskData(taskText: String, totalSecond: Int) {
        let task = Task()
        // realmへのデータ登録
        let realm = try! Realm()
        try! realm.write {
            task.taskName = taskText
            task.taskTime = totalSecond
            realm.add(task)
        }
    }

    // realmからデータを取得する
    func getTaskData() -> [Task] {
        let realm = try! Realm()
        // 当日の日付
        let now = Date()
        let startDay = Calendar.current.startOfDay(for: now)

        // 翌日の00:00:00
        guard
            let endDay = Calendar.current.date(
                byAdding: .day, value: 1, to: startDay)
        else {
            return []
        }
        // 登録日付を本日かつ、論理削除false
        // isDoneで並べ替える
        let result = realm.objects(Task.self).filter(
            "registerDate >= %@ AND registerDate < %@",
            startDay, endDay
        )
        .map {
            $0
        }
        return Array(result)
    }

    func checkRequestReview() {
        // レビューリクエストの条件を満たしているか確認
        // 登録データ数を取得
        let taskCount = getTaskData().count
        // レビューリクエストを以前表示させた日付を取得
        let showDisplayDay =
            UserDefaults.standard.object(
                forKey: "AppStoreReviewDate") as? Date
        // 本日日付
        let today = Date()
        // レビューリクエストを表示させた日付がnilか、日付が今日より前かつtaskDataが5件以上だった場合
        if (showDisplayDay == nil || showDisplayDay! < today) && taskCount > 5 {
            if let scene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene
            {
                AppStore.requestReview(in: scene)
                // 本日日付をUserDefaultsに保存
                // 3ヶ月後の日付を指定
                let calendar = Calendar.current
                let threeMonthsLater = calendar.date(
                    byAdding: .month, value: 3, to: today)
                let oneSecondsLater = calendar.date(
                    byAdding: .second, value: 1, to: today)
                UserDefaults.standard.set(
                    oneSecondsLater, forKey: "AppStoreReviewDate")

            }

        }

    }

}
