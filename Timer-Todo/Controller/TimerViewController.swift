//
//  TimerViewController.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/23.
//

import GoogleMobileAds
import UIKit

class TimerViewController: UIViewController, BannerViewDelegate {
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var timerDate: UILabel!
    @IBOutlet weak var timerSegmentButton: UISegmentedControl!
    var timer: Timer!
    var date: Date!
    private var isMobileAdsStartCalled = false
    private var isViewDidAppearCalled = false
    @IBOutlet weak var bannerView: BannerView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewDidLoad() {
        // adUnitIdを取得
        bannerView.adUnitID =
            Bundle.main.object(
                forInfoDictionaryKey: "AdMobSettingViewBannerAdUnitId")
            as? String
        bannerView.rootViewController = self
        bannerView.delegate = self
        GoogleMobileAdsConsentManager.shared.gatherConsent(from: self) {
            [weak self] consentError in
            guard let self else { return }

            if let consentError {
                print("Error: \(consentError.localizedDescription)")
            }
            // 同意が得られれば SDK を初期化
            if GoogleMobileAdsConsentManager.shared.canRequestAds {
                self.startGoogleMobileAdsSDK()
            }
        }

        // 前回セッションで同意済みならすぐに SDK 起動
        if GoogleMobileAdsConsentManager.shared.canRequestAds {
            startGoogleMobileAdsSDK()
        }
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

    @objc func updateTimer() {
        date = Date()
        timerText.text = TimerUtil.convertDateToTimerDisplayFormat(date: date)
    }

    @objc func updateReverseTimer() {
        date = Date()
        timerText.text = TimerUtil.getRemainingTimeInDay(
            currentDate: date)
    }
    // 画面を離れる際にTimerを破棄
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func startGoogleMobileAdsSDK() {
        DispatchQueue.main.async {
            guard !self.isMobileAdsStartCalled else { return }

            self.isMobileAdsStartCalled = true

            // Initialize the Google Mobile Ads SDK.
            MobileAds.shared.start()

            if self.isViewDidAppearCalled {
                self.loadBannerAd()
            }
        }
    }

    func loadBannerAd() {
        let viewWidth = view.frame.inset(by: view.safeAreaInsets).width

        // Here the current interface orientation is used. Use
        // GADLandscapeAnchoredAdaptiveBannerAdSizeWithWidth or
        // GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth if you prefer to load an ad of a
        // particular orientation
        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(
            width: viewWidth)

        bannerView.load(Request())
    }
    @IBAction func tapSegmentButton(_ sender: UISegmentedControl) {
        timer.invalidate()
        timer = nil
        selectedSegmetnIndex(index: sender.selectedSegmentIndex)
    }

    func selectedSegmetnIndex(index: Int) {
        switch index {
        case 0:
            // 普通の時計
            // 時計の更新処理
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(updateTimer),
                userInfo: nil,
                repeats: true)
        case 1:
            // 逆時計
            // 逆時計の更新処理
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(updateReverseTimer),
                userInfo: nil,
                repeats: true)
        default:
            // defaultはないが、エラー回避のために追加
            break
        }
    }

}
