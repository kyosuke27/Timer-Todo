//
//  SceneDelegate.swift
//  Timer-Todo
//
//  Created by kyosuke on 2025/04/22.
//

import Onboard
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene, willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard (scene as? UIWindowScene) != nil else { return }
        let isFirst = UserDefaults.standard.bool(forKey: "isFirstView")
        if !isFirst{
            // 初回起動なので、Onboardingを表示
            createOnboard()
            // UserDefaultsに初回起動フラグを保存
            UserDefaults.standard.set(true, forKey: "isFirstView")
        }
        
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    // onboarding
    func createOnboard() {
        // トップオンボーディング画面
        let topPage = OnboardingContentViewController(
            title: "Todyタスクへようこそ！",
            body:
                "あなたの「今日」にフォーカスした、シンプル×パワフルなタスク管理アプリです。\n今日のタスクをクリアするたびに、達成感と集中力が高まる――\nTodyタスクで、あなたの一日をもっとクリアに、もっともっと充実させましょう！",
            image: UIImage(named: "timer"), buttonText: "", action: nil)
        // TopPageのフォント設定
        topPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        topPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        topPage.view.backgroundColor = .white
        // フォント色を黒にする
        topPage.titleLabel.textColor = .black
        topPage.bodyLabel.textColor = .black
        // paddingの設定
        topPage.bottomPadding = 20
        
        // 時計画面の説明
        let timerPage = OnboardingContentViewController(
            title: "いま、この瞬間をキャッチ",
            body: "大きなデジタル時計で現在時刻をひと目で確認。\n画面上部の日付ラベルで「今日」がいつかをしっかり把握。\n",
            image: UIImage(named: "TimerScene"), buttonText: "", action: nil)
        // 時計画面の設定
        timerPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        timerPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        timerPage.view.backgroundColor = .white
        // フォント色を黒にする
        timerPage.titleLabel.textColor = .black
        timerPage.bodyLabel.textColor = .black
        // paddingの設定
        timerPage.topPadding = 50
        
        // タスク画面の説明
        let taskListPage = OnboardingContentViewController(
            title: "今日のタスクに集中",
            body:
                "ここに並ぶのは「今日だけ」のタスク。\n過去のタスクは自動で非表示に。\n一日の範囲に絞ることで、やるべきことが明確になり、生産性アップをサポートします。",
            image: UIImage(named: "TaskList"), buttonText: "", action: nil)
        // タスク画面の設定
        taskListPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        taskListPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        taskListPage.view.backgroundColor = .white
        // フォント色を黒にする
        taskListPage.titleLabel.textColor = .black
        taskListPage.bodyLabel.textColor = .black
        // paddingの設定
        taskListPage.topPadding = 50
        
        // タスク追加画面の説明
        let addTaskPage = OnboardingContentViewController(
            title: "タスクをカンタン登録", body: "「やること」を入力\n所要時間」を分単位で設定するだけで簡単登録！",
            image: UIImage(named: "AddTask"), buttonText: "", action: nil)
        // タスク追加画面の設定
        addTaskPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        addTaskPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        addTaskPage.view.backgroundColor = .white
        // フォント色を黒にする
        addTaskPage.titleLabel.textColor = .black
        addTaskPage.bodyLabel.textColor = .black
        // paddingの設定
        addTaskPage.topPadding = 50
        
        // タスク実行画面の説明
        let doTaskPage = OnboardingContentViewController(
            title: "タイマーで集中管理",
            body:
                "画面中央に 残り時間 と プログレスバー を大きく表示。\n視覚的なタイマーで「いま、このタスク」に集中し、クリアするたびに達成感を実感しましょう！\n",
            image: UIImage(named: "DoTask"), buttonText: "", action: nil)
        // タスク実行画面の設定
        doTaskPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        doTaskPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        doTaskPage.view.backgroundColor = .white
        // フォント色を黒にする
        doTaskPage.titleLabel.textColor = .black
        doTaskPage.bodyLabel.textColor = .black
        // paddingの設定
        doTaskPage.topPadding = 50
        
        // 設定画面の説明
        let settingPage = OnboardingContentViewController(
            title: "設定",
            body: "ページアプリのカラーテーマの変更も可能です。\nお好きな色を選んでアプリの雰囲気を変えてみましょう。",
            image: UIImage(named: "Setting"), buttonText: "始める",
            action: {
                // 最後のページなのでメイン画面への遷移
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeView =
                    storyboard.instantiateViewController(
                        withIdentifier: "TaskTabController")
                    as! TaskTabController
                self.window?.rootViewController = homeView
                self.window?.makeKeyAndVisible()
            })
        // 設定画面の設定
        settingPage.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 30)
        settingPage.bodyLabel.font = UIFont(name: "HelveticaNeue", size: 20)
        settingPage.view.backgroundColor = .white
        // フォント色を黒にする
        settingPage.titleLabel.textColor = .black
        settingPage.bodyLabel.textColor = .black
        settingPage.actionButton.setTitleColor(.white, for: .selected)
        settingPage.actionButton.backgroundColor = .gray
        settingPage.actionButton.layer.cornerRadius = 10
        // paddingの設定
        settingPage.topPadding = 50

        // 背景色を設定
        let onboardingVC = OnboardingViewController(
            backgroundImage: UIImage(named: "background"),
            contents: [
                topPage, timerPage, taskListPage, addTaskPage, doTaskPage,
                settingPage,
            ])
        onboardingVC?.pageControl.tintColor = .black
        // 背景色を白に設定
        window?.rootViewController = onboardingVC
    }

}
