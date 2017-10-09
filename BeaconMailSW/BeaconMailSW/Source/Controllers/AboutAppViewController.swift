//
//  AboutAppViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class AboutAppViewController: BaseViewController {
    
    @IBOutlet weak var swGetMailBg: UISwitch!
    
    @IBOutlet weak var lblAboutApp: UILabel!
    @IBOutlet weak var btnTutorial: UIButton!
    @IBOutlet weak var btnPolicy: UIButton!
    @IBOutlet weak var lblReceiveBackground: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iniliziazeView()
        setTitleLocalizeString()
    }
    
    func setTitleLocalizeString() {
        self.setNavWithImageAndTitle("ic_info.png", title: "toolbar_about".localizedString)
        
        self.lblAboutApp.text = "about_detail".localizedString
        //self.lblAboutApp.attributedText = "about_detail".localizedString.attributedString
        
        self.lblReceiveBackground.text = "receive_background".localizedString
                
        self.btnTutorial.setTitle("terms_of_service".localizedString, for: .normal)
        self.btnPolicy.setTitle("privacy_policy".localizedString, for: .normal)
        
        //Fix bug show underline title button
        self.btnTutorial.setBackgroundImage(UIImage(), for: UIControlState.normal)
        self.btnPolicy.setBackgroundImage(UIImage(), for: UIControlState.normal)
        
    }
    
    func iniliziazeView()
    {
        self.swGetMailBg.setOn(AppConfig.getMailBackground, animated: true)
        
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        // pass data to next view
        let viewController = segue.destination as! TutorialViewController
        
        if (segue.identifier == "gotoTermPolicy") {
            
            viewController.tutorial = false
            
        }else if (segue.identifier == "gotoTermOfUse")
        {
            viewController.tutorial = true
        }
    }
    @IBAction func swGetMailBgChangeValue(_ sender: UISwitch) {
        AppConfig.getMailBackground = sender.isOn
    }
    
}
