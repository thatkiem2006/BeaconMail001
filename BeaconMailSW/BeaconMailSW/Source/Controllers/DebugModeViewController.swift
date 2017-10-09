//
//  DebugModeViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation

class DebugModeViewController: BaseViewController,UIAlertViewDelegate {
    
    // IBOutlet
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet var btnXMLConfigOption: [UIButton]!
    @IBOutlet weak var textFieldUrl: UITextField!
    fileprivate let urlXMLConfigOption = [
        "https://idio.sakura.ne.jp/bm3/01C4D1300D37D1AD07A961/configuration.xml",
        "https://bitbucket.org/daink/datapublic/raw/6d3212e89d716e74eb2c5835c4a8c6d537b3d7ee/bm3.xml"]
    
    // MARK: App LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // set boder for buttons
        self.buttonSave.setBorder(1, radius: 4, color: UIColor(rgba: "#0079FF"))
        for btn in self.btnXMLConfigOption {
            btn.setBorder(1, radius: 4, color: UIColor(rgba: "#0079FF"))
        }
        self.textFieldUrl.text = AppConfig.xml_url_configuration
        // create title View
        self.setNavWithImageAndTitle("ic_debug_mode.png", title: "デバッグモード")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: Functions
    func initView() {
        // set text beaconinfo
        
    }
    
    func resetView() {
        
    }
    
    // MARK: IBAction
    @IBAction func onTouchButtonSave(_ sender: AnyObject) {
        // create alert
        let alertView = UIAlertController(title: "", message: MESSAGE_DEBUG_SAVE, preferredStyle: .alert)
        
        // cancel
        alertView.addAction(UIAlertAction(title: "いいえ", style: .default, handler:nil))
        alertView.addAction(UIAlertAction(title: "はい", style: .default, handler: { (alertAction) -> Void in
            if let url = self.textFieldUrl.text {
                AppConfig.xml_url_configuration = url
                self.saveConfig()
            }
        }))
        present(alertView, animated: true, completion: nil)    }
    
    @IBAction func btnChangeXMLURLClicked(_ sender: UIButton) {
        if sender.tag < urlXMLConfigOption.count {
            self.textFieldUrl.text = urlXMLConfigOption[sender.tag]
        }
    }
    
    // MARK: Beacon Detect Delegate
    func saveConfig() {
        var vc = self.presentedViewController
        while let pre = vc?.presentedViewController{
            vc = pre
        }
        vc?.dismiss(animated: false, completion: nil)
        
    }
    
    func resetConfig(){
        
    }
}
extension UIButton {
    func setBorder(_ width: CGFloat = 1, radius: CGFloat = 1,color: UIColor) {
        self.layer.cornerRadius = radius
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
