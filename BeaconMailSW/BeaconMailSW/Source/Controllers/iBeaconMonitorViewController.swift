//
//  iBeaconMonitorViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreLocation
class iBeaconMonitorViewController: UITableViewController {
    
    var iBeaconList = [BeaconInfo]()
    var iBeaconInSection = [BeaconInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(didRangeBeacons), name: NSNotification.Name(rawValue: kDidRangeBeaconsNotification), object: nil)                
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kDidRangeBeaconsNotification), object: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iBeaconList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier);
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: identifier)
        }
        let beacon = iBeaconList[indexPath.row]
        cell?.textLabel?.text = beacon.description
        cell?.detailTextLabel?.text = beacon.uuid
        return cell!;
    }
    
    func didRangeBeacons(_ notification: Foundation.Notification) {
        let beacons = notification.userInfo?["beacons"] as? [CLBeacon]
        let region = notification.userInfo?["region"] as? CLBeaconRegion
        if let beacons = beacons, beacons.count > 0 {
            iBeaconInSection = beacons.map { (clBeacon) -> BeaconInfo in
                let beaconBean = BeaconInfo()
                beaconBean.uuid = clBeacon.proximityUUID.uuidString
                beaconBean.major = "\(clBeacon.major)"
                beaconBean.minor = "\(clBeacon.minor)"
                beaconBean.rssi = "\(clBeacon.rssi)"
                beaconBean.identifier = "\(region?.identifier)"
                beaconBean.proximity = clBeacon.proximity
                let key = "\(beaconBean.uuid)\(beaconBean.minor)\(beaconBean.major)"
                return beaconBean
            }
            
            DispatchQueue.main.async {
                self.iBeaconList = self.iBeaconInSection
                self.tableView.reloadData()
            }
        }
    }
    
}
