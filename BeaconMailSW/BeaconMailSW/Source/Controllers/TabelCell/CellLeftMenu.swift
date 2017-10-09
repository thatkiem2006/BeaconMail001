//
//  CellLeftMenu.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

@objc protocol CellLeftMenuDelegate{
    func cellLeftMenuTouchBtnLock(_ menuInfo:LeftMenuInfo?)
    func cellLeftMenuTouchBtnTrash(_ menuInfo:LeftMenuInfo?)
}
class CellLeftMenu: UITableViewCell {
    
    // IBOutlet
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelBadge: UILabel!
    @IBOutlet weak var btnLock: UIButton!
    @IBOutlet weak var btnTrash: UIButton!
    var menuInfo:LeftMenuInfo?
    
    // delegate
    var delegate:CellLeftMenuDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //        print("awakeFromNib")
        self.labelBadge.layer.cornerRadius = self.labelBadge.frame.size.height/2
        self.labelBadge.layer.masksToBounds = true
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //        print("layoutSubviews")
        
        // set background for label
        self.labelBadge.backgroundColor = UIColor.red
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK:
    func setupCell(_ menuInfo:LeftMenuInfo, indexPath:IndexPath, isLock:Bool, isDetectingBeacon: Bool) {
        // set menuinfo
        self.menuInfo = menuInfo
        // reset button status
        self.btnTrash.isHidden = true
        self.imageViewIcon.isHidden = false
        self.btnLock.isHidden = true
        self.labelName.text = menuInfo.name
        self.backgroundColor = UIColor.white
        self.btnTrash.isHidden = !isLock
        self.btnLock.setImage(UIImage.bmImage( "ic_unlocked"), for: UIControlState())
        // for case menu item is ibeacon
        if let ibeaconItem = menuInfo.beaconInfo {
            if BeaconDetectManager.shared.isDetectingBeacon(ibeaconItem) && ibeaconItem.uuid.isEmpty == false {
                self.backgroundColor = UIColor(rgba: COLOR_HEX_BEACON_DETECT)
                self.btnTrash.isHidden = true
            }else if ibeaconItem.protected == true {
                self.backgroundColor = UIColor(rgba: COLOR_HEX_BEACON_PROTECT)
                self.btnLock.setImage(UIImage.bmImage( "ic_locked"), for: UIControlState())
                self.btnTrash.isHidden = true
            }
        }
        
        // In cases menu item is geofence, if have not detecting beacon, detecting geofence will have red color.
        if let geofenceItem = menuInfo.geofenceInfor {
            if !isDetectingBeacon && LocationManager.shared.isDetectingGeofence(geofenceItem) {
                self.backgroundColor = UIColor(rgba: COLOR_HEX_BEACON_DETECT)
                self.btnTrash.isHidden = true
            }
        }
        
        // Image beacon
        if menuInfo.type == .beacon || menuInfo.type == .geofence{
            self.imageViewIcon.loadImageWithURL(URL(string: menuInfo.imageIcon))
            self.btnLock.isHidden = !isLock
        }else {
            self.btnTrash.isHidden = true
            self.imageViewIcon.image = UIImage.bmImage(menuInfo.imageIcon)
        }
        
        // defaut beacon
        if indexPath.row == 0 {
            self.btnTrash.isHidden = true
            self.btnLock.isHidden = true
        }
        self.imageViewIcon.isHidden = !self.btnTrash.isHidden
        
        
        // label badge
        if menuInfo.unreadCnt == 0 {
            self.labelBadge.isHidden = true
            
        }else {
            self.labelBadge.isHidden = false
            self.labelBadge.text = "\(menuInfo.unreadCnt)"
            if isLock == true {
                self.labelBadge.isHidden = !self.btnLock.isHidden
            }
        }
        
    }
    @IBAction func onTouchBtnLock(_ sender: AnyObject) {
        
        self.delegate?.cellLeftMenuTouchBtnLock(self.menuInfo)
        
    }
    
    @IBAction func onTouchBtnTrash(_ sender: UIButton) {
        self.delegate?.cellLeftMenuTouchBtnTrash(self.menuInfo)
    }
}
