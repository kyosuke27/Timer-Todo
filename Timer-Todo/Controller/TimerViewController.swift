//
//  TimerViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/23.
//

import UIKit
import GoogleMobileAds

class TimerViewController: UIViewController {
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var timerDate: UILabel!
    var timer: Timer!
    var date: Date!
    var bannerView: BannerView!

    override func viewDidLoad() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width
        //        bannerView.adUnitID =
        //            Bundle.main.object(
        //                forInfoDictionaryKey: "AdMobSettingViewBannerAdUnitId")
        //            as? String
        let adaptiveSize = currentOrientationAnchoredAdaptiveBanner(
            width: viewWidth)
        bannerView = BannerView(
            adSize: adaptiveSize)
        bannerView.adUnitID =
            Bundle.main.object(
                forInfoDictionaryKey: "AdMobSettingViewBannerAdUnitId")
            as? String
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
        
        let date = Date()
        timerDate.text = TimerUtil.convertDateToDisplayFormat(date: date)
        // ダークモードの判定
        if UITraitCollection.current.userInterfaceStyle == .dark {
            timerDate.textColor = .black
        } else {
            timerDate.textColor = .white
        }
        // タイマーの初期化
        timerText.text = TimerUtil.convertDateToTimerDisplayFormat(date: date)
        // タイマーの設定
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
    
    func addBannerViewToView(_ bannerView: BannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      // This example doesn't give width or height constraints, as the provided
      // ad size gives the banner an intrinsic content size to size the view.
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: view.safeAreaLayoutGuide,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
        NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
    }

    @objc func updateTimer() {
        date = Date()
        timerText.text = TimerUtil.convertDateToTimerDisplayFormat(date: date)
    }
    // 画面を離れる際にTimerを破棄
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }

    // 画面を戻る際にTimerを再設定
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // タイマーの設定
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateTimer),
            userInfo: nil,
            repeats: true)
    }
}
