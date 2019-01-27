//
//  AppDelegate.swift
//  NWHacks2019
//
//  Created by Nathan Tannar on 2019-01-26.
//  Copyright © 2019 Nathan Tannar. All rights reserved.
//

import UIKit
import UserNotifications
import RxSwift
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var audioRecorder: AVAudioRecorder!
    var didStart = false

    var filePath: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("sample.wav")
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Log.info("Starting App...")
        
        AppRouter.shared.start(with: launchOptions)

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        AppRouter.shared.window?.isVoiceIDIndicatorHidden = true
        AppRouter.shared.window?.isPrivacyBlurEnabled = true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if didStart {
            AppRouter.shared.window?.isVoiceIDIndicatorHidden = false
            AppRouter.shared.window?.isPrivacyBlurEnabled = true
            recordAudio()
        } else {
            didStart = true
        }
    }

    func recordAudio() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        audioRecorder = try! AVAudioRecorder(url: filePath, settings: settings)
        audioRecorder.delegate = self
        audioRecorder.record(atTime: 2, forDuration: 6)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return false
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
        Log.info("didRegisterForRemoteNotificationsWithDeviceToken: \(tokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        if (error as NSError).code == 3010 {
            Log.debug("Push notifications are not supported in the iOS Simulator.")
        } else {
            Log.error("didFailToRegisterForRemoteNotificationsWithError: \(error)")
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable: Any]) {
    }

    private func requestPushNotificationAuthorization(for application: UIApplication) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { accepted, error in
            guard accepted else {
                return
            }
            DispatchQueue.main.async {
                application.registerForRemoteNotifications()
            }
        }
    }

}

extension AppDelegate: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            AppRouter.shared.window?.prepareVoidId()
            VoiceIDService.shared.authenticate(url: filePath).observeOn(MainScheduler.instance).subscribe { event in
                switch event {
                case .completed:
                    AppRouter.shared.window?.isPrivacyBlurEnabled = false
                    AppRouter.shared.window?.voiceIdSuccess()
                case .error(let error):
                    AppRouter.shared.window?.voiceIdFailed()
                    self.recordAudio()
                    Log.error(error)
                }
            }.disposed(by: disposeBag)
        }
    }
}
