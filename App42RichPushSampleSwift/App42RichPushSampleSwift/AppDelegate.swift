//
//  AppDelegate.swift
//  App42RichPushSampleSwift
//
//  Created by Purnima on 11/04/17.
//  Copyright © 2017 Shephertz. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let apiKey =    "b400539bfa288129821def96a087c1c913e9eeae3481afda786c5abb3895bf90"
    let secretKey = "31f2afbf5110e7bde7f0436765805877573c16851562dfedb95b47417b8479b9"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        App42API.initialize(withAPIKey: apiKey, andSecretKey: secretKey)
        App42API.setLoggedInUser("Purnima_123")
        App42API.enableApp42Trace(true)
        
        App42API.setBaseUrl("https://api.shephertz.com")
        App42API.setEventBaseUrl("https://analytics.shephertz.com")
        
        DispatchQueue.main.async {
            self.registerForPush()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    private func registerForPush() {
        
        let center  = UNUserNotificationCenter.current()
        center.delegate = self
        
        // request permissions
        center.requestAuthorization(options: [.sound, .alert, .badge]) {
            (granted, error) in
            if (granted) {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func registerUserForPushNotificationToApp42Cloud(deviceToken : String) {
        
        let pushObj = App42API.buildPushService() as! PushNotificationService
        
        pushObj.registerDeviceToken(deviceToken as String!, withUser: App42API.getLoggedInUser(), completionBlock: { (true , test, error) in
        })
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("receive push notification user info: \(userInfo)")

        let pushManager : App42RichPushManager = App42RichPushManager()
        pushManager.handleRichPush(pushInfo: userInfo)
        
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("device token:- \(token)")
        registerUserForPushNotificationToApp42Cloud(deviceToken: token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("remote notification error: \(error.localizedDescription)")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didreceive response: \(response.notification.request.content.userInfo)")
        
        let pushManager : App42RichPushManager = App42RichPushManager()
        pushManager.handleRichPush(pushInfo: response.notification.request.content.userInfo)
        
        completionHandler()
    }
    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("noification will present: \(notification)")
//        
//        NSLog("Userinfo: \(notification.request.content.userInfo)");
//        
//        completionHandler(.alert)
//        
//    }

}

