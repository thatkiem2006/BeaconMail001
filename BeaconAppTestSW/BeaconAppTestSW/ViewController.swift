//
//  ViewController.swift
//  BeaconAppTestSW
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import BeaconMailSW
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        testFW()
    }
    @IBAction func startBeaconMail(sender: AnyObject) {
        
    }
    
    func testFW() {
        BeaconMail.open(UIApplication.shared, inViewController: self)
    }
    
}
