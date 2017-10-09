//
//  BaseNavigationViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

enum NaviName:Int {
    case webview
    case favorite
    case beacon
    case info
    case debug_MODE
    case debug_STATUS_SCREEN
    func description()->String {
        switch self {
        case .webview:
            return "naviWebView"
        case .favorite:
            return "naviFavorite"
        case .beacon:
            return "naviMessageBox"
        case .info:
            return "naviAboutApp"
        case .debug_MODE:
            return "naviModeDebug"
        case .debug_STATUS_SCREEN:
            return "statusScreen"
        }
    }
}

class BaseNavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
