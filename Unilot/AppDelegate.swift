//
//  AppDelegate.swift
//  Unilot
//
//  Created by Alyona on 9/5/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
    
        
        
        NotifApp.registerForPushNotifications(application)
        
        //0 
        // removw badge
        application.applicationIconBadgeNumber = 0;

        
        // 1
        // Check if launched from notification

        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any] {
            // 2
            
            NotifApp.parseNotification(notification, isOpened: false)
            
            // 3
        }
        
        return true
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
        current_controller_core?.onUserOpenView()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        current_controller_core?.onUserCloseView()
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        let aps = userInfo as! [String: Any]
        
        NotifApp.parseNotification(aps, isOpened: true)
        
        completionHandler(.newData)
        
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable: Any], completionHandler: @escaping () -> Void) {
        // 1
        
        let aps = userInfo as! [String: Any]
        
        NotifApp.parseNotification(aps, isOpened: true)
        
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
        print("Device Token: ", tokenString)
        
        NotifApp.startAfterAnswerFromRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register: ", error.localizedDescription)
                
        
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

