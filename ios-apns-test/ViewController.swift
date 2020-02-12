//
//  ViewController.swift
//  ios-apns-test
//
//  Created by jhseo on 2020/02/11.
//  Copyright © 2020 jhseo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func localNotificationBtnDidTap(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Local Notification Title"
        content.subtitle = "Local Notification Subtitle"
        content.body = "Local Notification body"
        content.userInfo = ["link": "https://github.com/jhseo"]

        // Notification Extension 필요
        if let imgURL = Bundle.main.url(forResource: "sample", withExtension: "jpg"),
            let attachment = try? UNNotificationAttachment(identifier: "image", url: imgURL, options: .none) {
            content.attachments = [attachment]
        }

        let bundleId = Bundle.main.bundleIdentifier ?? ""
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: bundleId, content: content, trigger: nil) // trigger 넣으면 타이머 설정할 수 있고 반복도 가능

        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    @IBAction func notificationSettingsBtnDidTap(_ sender: Any) {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsUrl)
    }
}

