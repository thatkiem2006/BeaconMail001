//
//  BaseListViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class BaseListViewController: BaseViewController {
    
    @IBOutlet weak var labelNoMail: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewBottomBar: UIView!
    
    
    //
    var listMail = [MailInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.labelNoMail.text = "mail_no_mails".localizedString
        
        let cellMessageNib = UINib(nibName: "CellMessage", bundle: Bundle(for: BaseListViewController.self))
        self.tableView.register(cellMessageNib, forCellReuseIdentifier: "CellMessage")
        
        self.hideBottomBar(true)
        self.setRightBarButton("menu_edit".localizedString,target:self, action:#selector(BaseListViewController.onTouchEditButton))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    // MARK: - Function
    func setStateView() {
        // check if has message or not
        let isHasMessage = (self.listMail.count == 0)
        self.labelNoMail.isHidden = !isHasMessage
        if isHasMessage == false {
            self.tableView.separatorColor = UIColor(rgba: "#E0E0E0")
        }else {
            self.tableView.separatorColor = UIColor.clear
        }
        if isHasMessage {
            self.setRightBarButton("menu_edit".localizedString,target:self, action:#selector(BaseListViewController.onTouchEditButton))
        }
        self.navigationItem.rightBarButtonItem?.isEnabled = !isHasMessage
    }
    
    func onTouchEditButton() {
        self.tableView.setEditing(true, animated: true)
        self.setRightBarButton("mail_cancel".localizedString,target:self, action:#selector(BaseListViewController.onTouchCancelButton))
        self.hideBottomBar(false)
    }
    
    func onTouchCancelButton() {
        self.tableView.setEditing(false, animated: true)
        self.setRightBarButton("menu_edit".localizedString,target:self, action:#selector(BaseListViewController.onTouchEditButton))
        self.hideBottomBar(true)
    }
    
    func hideBottomBar(_ isHidden:Bool) {
        self.viewBottomBar.isHidden = isHidden
        var insets = UIEdgeInsetsMake(0, 0, 0, 0)
        if isHidden == false {
            insets = UIEdgeInsetsMake(0, 0, self.viewBottomBar.frame.size.height, 0)
        }
        self.tableView.contentInset = insets
        self.tableView.scrollIndicatorInsets = insets
    }

}
