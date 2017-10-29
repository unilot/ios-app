//
//  AppDelegate.swift
//  Unilot
//
//  Created by Alyona on 9/5/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
                
        registerForPushNotifications(application)
        application.applicationIconBadgeNumber = 0;
        
        
        // Check if launched from notification
        // 1
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any] {
            // 2

            parseNotification(notification, isOpened: false)
            
            // 3
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
    
        
        
        
   //MARK: - remote stuff
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        print("url recieved:", url);
        print(url.pathComponents);
        
        
        let args = url.absoluteString.components(separatedBy: "id_listing=")
        if args.count == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NOTIFICATION_OPEN_SHARE_LINK"), object: nil, userInfo: ["id_listing" : args[1] ])
            
        }
        
        
        return true
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        let aps = userInfo as! [String: Any]
        
        parseNotification(aps, isOpened: true)
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        // 1
        
        let aps = userInfo as! [String: Any]
        
        // 2
        
        parseNotification(aps, isOpened: true)
        
        completionHandler()
    }
    
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        if notificationSettings.types != UIUserNotificationType() {
            application.registerForRemoteNotifications()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenChars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var tokenString = kEmpty
        
        for i in 0..<deviceToken.count {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        tokenForNotifications = tokenString
        print("Device Token: ", tokenString)
        
        startAfterAnswerFromRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: ", error.localizedDescription)
        
        startAfterAnswerFromRemoteNotifications()
        
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
    
    
    //MARK: -
    
     
    func registerForPushNotifications(_ application: UIApplication) {
        
        let viewAction = UIMutableUserNotificationAction()
        viewAction.identifier = "VIEW_IDENTIFIER"
        viewAction.title = "View"
        viewAction.activationMode = .foreground
        
        let newsCategory = UIMutableUserNotificationCategory()
        newsCategory.identifier = "NEWS_CATEGORY"
        newsCategory.setActions([viewAction], for: .default)
        
        let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: [newsCategory])
        application.registerUserNotificationSettings(notificationSettings)
        
        perform(#selector(AppDelegate.startAfterAnswerFromRemoteNotifications), with: nil, afterDelay: 5)
        
    }
    
    
    func parseNotification(_ notificationDictionary:[String: Any], isOpened: Bool) {
        
        print(notificationDictionary)
        
        notification_data.append( notificationDictionary )
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "NOTIFICATION_CAME"), object: nil)

    }
    
    
    func startAfterAnswerFromRemoteNotifications(){
        if  !startWas {
            startWas = true
            NotificationCenter.default.post(name: Notification.Name(rawValue: "enter_after_start"), object: nil)
        }
    }


}

