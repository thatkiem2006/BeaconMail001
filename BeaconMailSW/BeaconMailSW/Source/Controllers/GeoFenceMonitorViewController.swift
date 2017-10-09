//
//  GeoFenceMonitorViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class GeoFenceMonitorViewController: UITableViewController {
    
    static var shared : GeoFenceMonitorViewController?
    static var tableData: [GeoFenceBean]! = [GeoFenceBean]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GeoFenceMonitorViewController.shared = self                
    }
    
    func didEnterRegionBlock(geofence: GeoFenceBean) {
        print("GeoFenceMonitorViewController > didEnterRegionBlock > geofence: ",geofence)
        self.addGeoFence(geofence)
    }

    func didExitRegionBlock(identifier: String) {
        print("GeoFenceMonitorViewController > didExitRegionBlock > identifier: ",identifier)
        self.removeGeoFence(identifier)
    }
    
    func addGeoFence(_ geoFence: GeoFenceBean) {
        //Check if exist -> return
        for geo in GeoFenceMonitorViewController.tableData {
            if geo.identifier == geoFence.identifier {
                return
            }
        }
        
        GeoFenceMonitorViewController.tableData.insert(geoFence, at: 0)
        self.tableView.reloadData()
        
    }
    
    func removeGeoFence(_ identifier: String) {
        GeoFenceMonitorViewController.tableData = GeoFenceMonitorViewController.tableData.filter({ (geo) -> Bool in
            geo.identifier != identifier
        })
        self.tableView.reloadData()
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GeoFenceMonitorViewController.tableData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        }
        let dataForCell = GeoFenceMonitorViewController.tableData[indexPath.row]
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.text = "\(dataForCell.latitude!) - \(dataForCell.longitude!), \(dataForCell.radius!) m"
        return cell!
    }
    
}

