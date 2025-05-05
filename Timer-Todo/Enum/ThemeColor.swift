import Foundation
import UIKit

enum ThemeColor: Int {
    case `default`
    case red
    case blue

    // 計算プロパティ
    var color: UIColor {
        // それぞれの色を選択した値から取得する
        switch self {
        case .default: return .white
        case .red: return UIColor.rgba(red: 210, green: 65, blue: 65, alpha: 1)
        case .blue:
            return UIColor.rgba(red: 65, green: 135, blue: 250, alpha: 1)
        }
    }
}

extension UIColor {
    static func rgba(red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor
    {
        return UIColor(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: alpha
        )
    }
}
