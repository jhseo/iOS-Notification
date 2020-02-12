//
//  SceneDelegate.swift
//  ios-apns-test
//
//  Created by jhseo on 2020/02/11.
//  Copyright © 2020 jhseo. All rights reserved.
//

import UIKit
import SafariServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}

extension SceneDelegate {
    /*
     [UNAuthorizationOptions]
     .badge : Display a number on the corner of the app's icon.
     .sound : Play a sound.
     .alert : Display text.
     .carPlay : Display notifications in CarPlay.
     .provisional : Post non-interrupting notifications. The user won't get a request for permission if you only use this option, but your notifications will only show silently in the Notification Center.
     .providesAppNotificationSettings : Indicate that the app has its own UI for notification settings.
     .criticalAlert : Ignore the mute switch and Do Not Disturb. You'll need a special entitlement from Apple to use this option as it's only meant to be used when absolutely necessary.
     */
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            print("Permission granted: \(granted)") // granted가 true이면 user가 push를 허용한 것이고 false면 허용하지 않은 것

            guard granted else { return }
            self?.getNotificationSettings()
        }
    }

    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")

            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

    /*
    [aps dictionary(user info)]
    {
      "aps": {
        "alert": "Test!",
        "sound": "default",
      },
      "link": "https://github/jhseo"
    }
    alert : This can be a string, like in the previous example, or a dictionary itself. As a dictionary, it can localize the text or change other aspects of the notification.
    badge : This is a number that will display in the corner of the app icon. You can remove the badge by setting this to 0.
    sound : Name of a custom notification sound's file located in the app. Custom notification sounds must be shorter than 30 seconds and have a few restrictions.
    thread-id : Use this key to group notifications.
    category : This defines the category of the notification, which is is used to show custom actions on the notification. You will explore this shortly.
    content-available : By setting this key to 1 , the push notification becomes silent. You will learn about this in the Silent Push Notifications section.
    mutable-content : By setting this key to 1 , your app can modify the notification before displaying it.
    */
extension SceneDelegate: UNUserNotificationCenterDelegate {
    // Push 눌렀을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        let userInfo = response.notification.request.content.userInfo
        if response.actionIdentifier == UNNotificationDismissActionIdentifier {
            print("Message Closed")
        } else if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            print("when click push message")
            guard let link = userInfo["link"] as? String else { return }

            print(link)
            if let url = URL(string: link) {
                let safariViewController = SFSafariViewController(url: url)
                window?.rootViewController?.present(safariViewController, animated: true, completion: nil)
            }
        }
        completionHandler()
    }

    // foreground에서도 notification 수신 허용
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler(.alert)
    }
}
