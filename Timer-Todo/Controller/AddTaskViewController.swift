import FSCalendar
import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{
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
        print("taskText : \(self.taskText.text!)")
        // Timerの値
        print("hour : \(self.hourArray[timerPickerView.selectedRow(inComponent: 0)])")
        print("minute : \(self.minuteArray[timerPickerView.selectedRow(inComponent: 1)])")
        print("second : \(self.secondArray[timerPickerView.selectedRow(inComponent: 2)])")
    }
}
