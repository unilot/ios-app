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



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        MemoryControll.init_defaults_if_any()
        
 
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }
        
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self

        }
        
        NotifApp.registerForPushNotifications(application)
        
        
        FirebaseApp.configure()
        
        Fabric.with([Crashlytics.self])
        
        // Set Background Fetch Intervall for background services / terminated app
//        UIApplication.shared.setMinimumBackgroundFetchInterval(10)
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [String: Any] {
            
            NotifApp.parseRemoteNotification(notification)
            
         }

        
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

