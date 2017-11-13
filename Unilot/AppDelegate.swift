//
//  AppDelegate.swift
//  Unilot
//
//  Created by Alyona on 9/5/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import Fabric
import Crashlytics

func sendNotification(_ message : String, _ key_id : String){
    
    if #available(iOS 10.0, *) {
        let content = UNMutableNotificationContent()
        content.title = app_name
        content.body = message
        content.sound = UNNotificationSound.default()
        let request = UNNotificationRequest(identifier: key_id, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            // handle error
        })
        
    } else {
        
        // Fallback on earlier versions
        
        let notification = UILocalNotification()
        notification.alertBody = message
        
        
        let fixdate = Date().timeIntervalSince1970 + 5
        notification.fireDate = Date(timeIntervalSince1970: fixdate)
        notification.userInfo = ["task_id" : key_id]
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
        
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 
        if !app_is_active {
            completionHandler([.alert, .badge, .sound])
        }
    

    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
//        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
             NotifApp.gotLocalUserNotifAnswer(response.notification.request.identifier)
//        }
        

        completionHandler()
    }
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        app_is_active = true
 
        FIRApp.configure()
        Fabric.with([Crashlytics.self])

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        

        NotifApp.registerForPushNotifications(application)
        
        
        // Set Background Fetch Intervall for background services / terminated app
        UIApplication.shared.setMinimumBackgroundFetchInterval(10)
        
        return true
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
 
        current_controller_core?.onUserCloseView()
        app_is_active = false

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        current_controller_core?.onUserOpenView()
        app_is_active = true

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        app_is_active = true

    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        app_is_active = false
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    
        
   //MARK: - remote stuff

     
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("url recieved:", url);
        print(url.pathComponents);
        
        
        let args = url.absoluteString.components(separatedBy: "from_user_id=")
       
        if args.count == 2 {
            
            
        }
        
        
        return true
        
    }
    
    // This method will be called when app received push notifications in foreground
 
    
    // Catching notifications in appdelegate
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        print("notification - tapped")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

        
//        sendNotification("drfkyughkjlkujyhgf","key")

        let aps = userInfo as! [String: Any]
        
        NotifApp.parseRemoteNotification(aps)
        
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        
        
         // 1
        let aps = userInfo as! [String: Any]
        
        NotifApp.parseRemoteNotification(aps)
        
        completionHandler()
    }
    
    // Handling action buttons and notifying where you need with notificationCenter
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
       

        // ios <= 9
        NotifApp.gotLocalUserNotifAnswer(responseInfo["task_id"] as! String)
        
        completionHandler()
    }
    
    
    //MARK: - device id for pushes
     
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = kEmpty
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        tokenForNotifications = tokenString
//        print("Device Token: ", tokenString)
        
        NotifApp.startAfterAnswerFromRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

        _ = message_to_Crashlytics(error : error)
 
        NotifApp.startAfterAnswerFromRemoteNotifications()
        
    }
    
    
    //MARK: - rotations

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if let navigationController = self.window?.rootViewController as? UINavigationController {
            if navigationController.visibleViewController is WhitePapersView {
                return UIInterfaceOrientationMask.all
            }
        }
        
        return UIInterfaceOrientationMask.portrait
    }
    
    

    
 }

