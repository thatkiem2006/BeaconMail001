//
//  SplashViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var btnTryAgain: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initForView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: - Initial
    func initForView() {
        downloadConfigXML()
    }
    //MARK: - Private
    @IBAction func btnTryAgainClicked(_ sender: AnyObject) {
        downloadConfigXML()
    }
    fileprivate func gotoTopViewControler() -> Void {
        let revealController = UIStoryboard.init(name: "Main", bundle: Bundle(for: SplashViewController.self)).instantiateViewController(withIdentifier: "revealViewController") as? SWRevealViewController
        self.present(revealController!, animated: false, completion: nil)
    }
    
    fileprivate func getConfigXMLFile(_ completionHandler: @escaping ((ConfigurationBean?) -> Void)) {
        print("getConfigXMLFile")

        var seconds = 0
        let lastTime = Common.convertStringToDate(UDGet(TIME_GET_PRESENT_XML) ?? "", format: FORMAT_DATE_YYYY_SS)
        
        
        let daysToLive = StaticData.shared.bmConfiguration?.daysToLive ?? 0
        
        
        
        print("getConfigXMLFile > daysToLive:%@",daysToLive)
        
        
        // Request new xmlConfig from server if the time > daysToLive
        
        if let lastTime = lastTime {
            seconds = Common.secondsFrom(lastTime, toDate: Date())
        } else {
            seconds = daysToLive * kDayToSecond // the fist time need load from server
        }
        
        if seconds >= (daysToLive * kDayToSecond) {
            print("REQUEST 2ND XML CONFIG")
            let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
            hub.bezelView.style = .solidColor
            hub.bezelView.color = UIColor.clear
            hub.offset.y = 130
            
            APIClient.shared.requestGetConfigXMLFile({ (config) in
                hub.hide(animated: true)
                completionHandler(config)
            })
        } else {
            print("LOAD LOCAL")
            ConfigurationBean.loadLocal({ (success, data) in
                if success {
                    completionHandler(data)
                    
                }else {
                    let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hub.bezelView.style = .solidColor
                    hub.bezelView.color = UIColor.clear
                    hub.offset.y = 130
                    
                    APIClient.shared.requestGetConfigXMLFile({ (config) in
                        hub.hide(animated: true)
                        completionHandler(config)
                    })
                }
            })
        }
//        UDSet(KEY_DOWNLOAD_CONFIG_SUCCESS, bool: true)
    }

    func downloadConfigXML() {
        self.btnTryAgain.isHidden = true
        self.getConfigXMLFile({ (config) in
            if let config = config{
                StaticData.shared.bmConfiguration = config
                if UDGet(KEY_FIRST_OPEN_APP) == false {
                    let beacon = Common.getDefaultBeacon()
                    beacon.mailGroup = config.infoGroup
                    Beacon.insert(beacon)
                    UDSet(KEY_FIRST_OPEN_APP, bool: true)
                }
                BeaconMail.reloadMonitoringRegion()//fix error
                DispatchQueue.main.async {
                    self.gotoTopViewControler()
                }
            }else {
                self.showAlert(withTitle: "", message: "server_error_try_connect".localizedString)
                self.btnTryAgain.isHidden = false
            }
        })
        
    }

}
