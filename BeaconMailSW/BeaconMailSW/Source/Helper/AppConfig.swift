//
//  AppConfig.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
let kGetMailInBackground = "key get mail in background"
class AppConfig: NSObject {
    fileprivate static let kKeyLatitude = "AppConfig old latitude"
    fileprivate static let kKeyLongitude = "AppConfig old longitude"
    fileprivate static let kXML_URL_CONFIG_KEY = "kXML_URL_CONFIG_KEY"
    fileprivate static let CONFIG_URL = "https://idio.sakura.ne.jp/bm3/01C4D1300D37D1AD07A961/configuration.xml"
    // set get mail in backfround
    static var getMailBackground:Bool {
        get {
            let defaults = UserDefaults.standard
            return defaults.bool(forKey: kGetMailInBackground)
        }
        
        set(value){
            let defaults = UserDefaults.standard
            defaults.set(value, forKey: kGetMailInBackground)
        }
    }
    static func moveToMenu() {
        if let appdegate = UIApplication.shared.delegate {
            if let rootViewController = getTopViewController() as? SWRevealViewController {
                rootViewController.revealToggle(nil)
            }
        }
    }
    
    //    static var oldLatitude:Double {
    //        get {
    //            let defaults = NSUserDefaults.standardUserDefaults()
    //            return defaults.doubleForKey(AppConfig.kKeyLatitude)
    //        }
    //
    //        set(value){
    //            let defaults = NSUserDefaults.standardUserDefaults()
    //            defaults.setDouble(value, forKey: AppConfig.kKeyLatitude)
    //        }
    //    }
    //    static var oldLongitude:Double {
    //        get {
    //            let defaults = NSUserDefaults.standardUserDefaults()
    //            return defaults.doubleForKey(AppConfig.kKeyLongitude)
    //        }
    //
    //        set(value){
    //            let defaults = NSUserDefaults.standardUserDefaults()
    //            defaults.setDouble(value, forKey: AppConfig.kKeyLongitude)
    //        }
    //    }
    
    static func initValueUserDefaults() {
        ConfigurationBean.loadLocal { (success, data) in
            if success {
                StaticData.shared.bmConfiguration = data
            }
        }
        
        if let language = Locale.preferredLanguages.first {
            let languageDict = Locale.components(fromIdentifier: language)
            if let languageCode = languageDict["kCFLocaleLanguageCodeKey"] {
                UDSet(kLanguage, value: languageCode as AnyObject)
            }
        }
        AppConfig.getMailBackground = true
        UDSet(KEY_DEBUG_MODE_ENABLE, bool: false)
    }
    
    static var xml_url_configuration:String {
        get {
            if let url: String = UDGet(AppConfig.kXML_URL_CONFIG_KEY) {
                return url
            }
            return AppConfig.CONFIG_URL
        }
        
        set(value){
            UDSet(value, object: AppConfig.kXML_URL_CONFIG_KEY as AnyObject)
        }
    }
    
}
extension UIWindow {
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController  = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(_ vc:UIViewController) -> UIViewController {
        if vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(presentedViewController.presentedViewController!)
            } else {
                return vc;
            }
        }
    }
}
