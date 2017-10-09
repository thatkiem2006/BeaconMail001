//
//  CellMessage.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class CellMessage: UITableViewCell {
    
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelUpdateDate: UILabel!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var viewReadMessage: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.viewReadMessage.layer.cornerRadius = self.viewReadMessage.frame.size.height/2
        self.viewReadMessage.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // set background for label
        self.viewReadMessage.backgroundColor = UIColor(rgba: "#0079FF")
    }
    
    func setupView(_ mailInfo:MailInfo) {
        self.labelUpdateDate.text = Common.convertDateToString(mailInfo.update_date, format: FORMAT_DATE_YYYY_MM)
        //        self.labelSubject.text = mailInfo.mail_id + ", " + mailInfo.subject
        self.labelSubject.text =  mailInfo.subject
        self.labelDescription.text = mailInfo.messageDescription.replacingOccurrences(of: "\n", with: " ")
        self.viewReadMessage.isHidden = mailInfo.is_read
    }
    
}
