//
//  TutorialViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    var tutorial:Bool = false
    
    override func viewDidLayoutSubviews() {
        self.textView.setContentOffset(.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.textView.scrollRangeToVisible(NSRange(location:0, length:0))
        self.textView.isScrollEnabled = true
        
        
        
        if self.tutorial
        {
            self.setNavTitle("toolbar_term_conditions".localizedString)
        }else
        {
            self.setNavTitle("toolbar_privacy_policy".localizedString)
        }
        
        if tutorial == true {
            var termCondition = Common.getTermCondition()
            termCondition = termCondition.replacingOccurrences(of: "<br />", with: "")
            
            self.textView.text = termCondition//termCondition.attributedString
            
        } else {
            var privacy = Common.getPrivacyPolicy()
            //self.textView.attributedText = privacy.attributedString
            privacy = privacy.replacingOccurrences(of: "<br />", with: "")
            self.textView.text = privacy
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // create menu button
        self.showMenuButton(false)
        
    }
}
