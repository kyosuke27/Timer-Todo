import Foundation
import UIKit

class PopupViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func tapCloseButton(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
}
