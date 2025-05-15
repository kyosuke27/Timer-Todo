import Foundation
import UIKit
import ChameleonFramework

enum ThemeColor: Int {
    case `default`
    case red
    case blue
    case green
    case purple
    case pink

    // 計算プロパティ
    var color: UIColor {
        // それぞれの色を選択した値から取得する
        switch self {
        case .default: return UIColor(named: "DefaultColor")!
        case .red: return UIColor.flatRed()
        case .blue: return UIColor.flatSkyBlue()
        case .green: return UIColor.flatGreen()
        case .purple: return UIColor.flatMagenta()
        case .pink: return UIColor.flatPink()
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
