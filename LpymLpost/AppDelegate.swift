//
//  AppDelegate.swift
//  LPymPost
//
//  Created by JOJO on 2021/10/28.
//

import UIKit
import AppTrackingTransparency


// com.croposts.likefilter


let AppName: String = "Likes+Photo"
let purchaseUrl = ""
let TermsofuseURLStr = "http://frequent-shock.surge.sh/Terms_of_use.html"
let PrivacyPolicyURLStr = "http://lamentable-sink.surge.sh/Facial_Privacy_Policy.html"

let feedbackEmail: String = "juliatorrilpo86@gmail.com"
let AppAppStoreID: String = ""





@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        NotificationCenter.default.addObserver(self, selector: #selector(applicDidBecomeActiveNotifi(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        registerNotifications(application)
        HightLigtingHelper.default.initSwiftStoryKit()
        NotificationCenter.default.post(name: .didFinishLaunching,
                                        object: [nil])
        
        
        
                 
        APLoginMana.fireAppInit()
        
        return true
    }
    
//    @objc func applicDidBecomeActiveNotifi(_ notifi: Notification) {
//        // Start the SDK (start the IDFA timeout set above, for iOS 14 or later)
//        trackeringAuthor()
//    }
    
//    func trackeringAuthor() {
//       
//        if #available(iOS 14, *) {
//            ATTrackingManager.requestTrackingAuthorization(completionHandler: {[weak self] status in
//                guard let `self` = self else {return}
//                
//            })
//        }
//    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        APLoginMana.receivesAuthenticationProcess(url: url, options: options)
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

