//
//  ListFavoriteViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class ListFavoriteViewController: BaseListViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create title View
        self.setNavWithImageAndTitle("ic_favorite.png", title: "menu_favorite".localizedString)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // get list mail farvorite
        self.listMail = MailBox.getAll(isFavorite: true)
        
        //sort
        if let sortMail = listMail as? [MailInfo] {
            self.listMail = sortMail.sorted(by: { (x, y) -> Bool in
                x.create_date! > y.create_date!
            })
        }                
        
        self.tableView.reloadData()
        
        // set state
        self.setStateView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - Function
    /*
     *
     *  deleteCellSelection
     */
    func deleteCellSelection()
    {
        // Delete what the user selected.
        if let selectedRows:[IndexPath] = self.tableView.indexPathsForSelectedRows
        {
            let deleteSpecificRows = selectedRows.count > 0;
            
            if (deleteSpecificRows)
            {
                var listDeleteMail = [MailInfo]()
                
                for selectionIndex in selectedRows
                {
                    listDeleteMail.append(self.listMail[selectionIndex.row])
                }
                
                // delete mail from db
                self.deleteMail(listDeleteMail,fromFavorite:true)
                
                // get mail from db
                self.listMail = MailBox.getAll(isFavorite: true)
                
                // reload tableView
                if (self.listMail.count + selectedRows.count) != self.tableView.numberOfRows(inSection: 0) {
                    self.tableView.reloadData()
                    
                } else {
                    self.tableView.deleteRows(at: selectedRows, with: UITableViewRowAnimation.automatic)
                }
                
                // show toast
                self.showToast("mail_has_deleted".localizedString)
                
            }
        }
    }
    // MARK: -IBAction
    @IBAction func onTouchButtonDelete(_ sender: AnyObject) {
        if #available(iOS 8.0, *) {
            // create alert
            let alertView = UIAlertController(title: "", message: MESSAGE_MAIL_DELETE, preferredStyle: .alert)
            
            // cancel
            alertView.addAction(UIAlertAction(title: "button_cancel".localizedString, style: .default, handler: { (alertAction) -> Void in
                print("onTouchButtonDelete : いいえ")
            }))
            
            // OK
            alertView.addAction(UIAlertAction(title: "button_ok".localizedString, style: .default, handler: { (alertAction) -> Void in
                print("onTouchButtonDelete : はい")
                // delete
                self.deleteMail()
                
            }))
            
            // show alert
            present(alertView, animated: true, completion: nil)
            
            
        }else
        {
            let alertView = UIAlertView()
            alertView.tag = 10
            alertView.title = ""
            alertView.message = MESSAGE_MAIL_DELETE
            alertView.delegate = self
            alertView.addButton(withTitle: "button_cancel".localizedString)
            alertView.addButton(withTitle: "button_ok".localizedString)
            alertView.show()
        }
        
        
    }
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMail.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellMessage") as! CellMessage
        
        // setup view
        let mailInfo = self.listMail[indexPath.row]
        cell.setupView(mailInfo)
        
        // return
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (tableView.isEditing == false) {
            
            if  let viewController = self.storyboard?.instantiateViewController(withIdentifier: "messageDetail") as? MessageDetailViewController {
                let mailInfo = self.listMail[indexPath.row]
                viewController.mailInfo = mailInfo
                if let beacon = mailInfo.beacon{
                    viewController.beaconInfo = beacon
                }
                viewController.geofence = mailInfo.geofence
                
                viewController.isFromListMailFavorite = true
                self.navigationController?.pushViewController(viewController as UIViewController, animated: true)
            }
            
            // deselect
            tableView.deselectRow(at: indexPath, animated: false)
        }
        
    }
    
    // MARK : UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 0
        {
            
        }else if buttonIndex == 1
        {
            // DELETE
            if alertView.tag == 10
            {
                
                // delete
                self.deleteMail()
            }
        }
    }
    
    func deleteMail() {
        
        self.deleteCellSelection()
        if self.listMail.count == 0 {
            self.onTouchCancelButton()
        }
        
        self.setStateView()
    }
}
