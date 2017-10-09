//
//  StatusScreenViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class StatusScreenViewController: UIViewController {
    @IBOutlet weak var txtIDFV: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDayToLive: UITextField!
    @IBOutlet weak var txtReadRecipeURL: UITextView!
    @IBOutlet weak var iBeaconTableView: UITableView!
    @IBOutlet weak var geoFenceTableView: UITableView!
    let bmConfig = StaticData.shared.bmConfiguration
    override func viewDidLoad() {
        super.viewDidLoad()
        initForView()
    }
    func initForView() {
        self.txtIDFV.text = DeviceInfo.getUUID()
        self.txtName.text = bmConfig?.profileName
        self.txtDayToLive.text = "\((bmConfig?.daysToLive)!)"
        self.txtReadRecipeURL.text = bmConfig?.readReceiptUrl
        self.iBeaconTableView.reloadData()
        self.geoFenceTableView.reloadData()
    }
}
extension StatusScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.iBeaconTableView {
            return bmConfig?.ibeaconList?.count ?? 0
        }else {
            return bmConfig?.geofenceList?.count ?? 0
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        var textLabel: String?
        if tableView == self.iBeaconTableView {
            let beacon = bmConfig?.ibeaconList![indexPath.row]
            textLabel = beacon?.uuid
        }else {
            let geofence = bmConfig?.geofenceList![indexPath.row] as! Region
            textLabel = geofence.description
        }
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        cell?.textLabel?.text = textLabel
        return cell!
    }
}
