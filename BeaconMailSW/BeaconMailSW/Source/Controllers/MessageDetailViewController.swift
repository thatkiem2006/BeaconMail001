//
//  MessageDetailViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class MessageDetailViewController: BaseViewController,UIWebViewDelegate ,UIAlertViewDelegate{
    
    @IBOutlet weak var labelUpdateDate: UILabel!
    @IBOutlet weak var webViewContent: UIWebView!
    @IBOutlet weak var labelSubject: UILabel!
    @IBOutlet weak var buttonAddFavorite: UIButton!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // variables
    var isFromListMailFavorite:Bool = false
    var isDisplayWebButton:Bool = false
    var mailInfo:MailInfo?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavigationTitle()
        
        self.buttonWeb.setTitle("menu_information".localizedString, for: UIControlState.normal)
        self.buttonWeb.setTitle("menu_information".localizedString, for: UIControlState.selected)
        
        self.mailInfo?.beacon = self.beaconInfo
        self.mailInfo?.geofence = self.geofence
        self.labelSubject.text = self.mailInfo?.subject
        self.labelSubject.sizeToFit()
        self.labelUpdateDate.text = Common.convertDateToString(self.mailInfo?.update_date, format: FORMAT_DATE_YYYY_MM)
        if (self.mailInfo?.message)!.isEmpty {
            self.loadHtmlBody()
        }else {
            self.webViewContent.loadHTMLString((self.mailInfo?.message)!, baseURL: nil)
            self.webViewContent.scalesPageToFit = true
        }
        self.mailInfo!.is_read = true
        MailBox.updateIsRead(self.mailInfo!, isRead: true, fromFavorite: self.isFromListMailFavorite)
                
    }
    
    func showNavigationTitle() {
        // default beacon
        if self.beaconInfo.isEqualBeacon(Common.getDefaultBeacon()) {
            self.setNavWithImageAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
        }else if let geo = self.geofence{
            self.setNavWithImageURLAndTitle(geo.profile?.iconURl ?? "", title: geo.mail?.name ?? "")
        }else {
            self.setNavWithImageURLAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // create menu button
        self.showMenuButton(false)
        
        // add button share
        let shareBarItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target: self, action: #selector(MessageDetailViewController.share))
        self.navigationItem.rightBarButtonItem = shareBarItem
        // if the prev controller is favoriteController
        self.buttonAddFavorite.isHidden = MailBox.checkMailExist(self.mailInfo!, isFavorite: true)
        if self.isFromListMailFavorite {
            self.buttonWeb.isHidden = true
        }else {
            if self.isDisplayWebButton == false {
                self.buttonWeb.isHidden = true
            }
        }
    }
    
    // MARK: - IBAction
    @IBAction func onTouchButtonFavorite(_ sender: AnyObject) {
        
        if #available(iOS 8.0, *) {
            // create alert
            let alertView = UIAlertController(title: "", message: "mail_add_favorite".localizedString, preferredStyle: .alert)
            
            // cancel
            alertView.addAction(UIAlertAction(title: "button_cancel".localizedString, style: .default, handler: { (alertAction) -> Void in
                //                print("onTouchButtonFavorite : いいえ")
            }))
            
            // OK
            alertView.addAction(UIAlertAction(title: "button_ok".localizedString, style: .default, handler: { (alertAction) -> Void in
                // Add favorite
                self.addFavorite()
                
            }))
            
            // show alert
            present(alertView, animated: true, completion: nil)
            
            
        }else {
            let alertView = UIAlertView()
            alertView.tag = 10
            alertView.title = ""
            alertView.message = "mail_add_favorite".localizedString
            alertView.delegate = self
            alertView.addButton(withTitle: "button_cancel".localizedString)
            alertView.addButton(withTitle: "button_ok".localizedString)
            alertView.show()
        }
        
    }
    
    @IBAction func onTouchButtonWeb(_ sender: AnyObject) {
        self.backToWebView(self.beaconInfo, geo: self.geofence)
    }
    
    
    @IBAction func onTouchButtonDelete(_ sender: AnyObject) {
        
        let cancelTitle = "button_cancel".localizedString
        let okTitle     = "button_ok".localizedString
        
        if #available(iOS 8.0, *) {
            // create alert
            let alertView = UIAlertController(title: "", message:MESSAGE_MAIL_DELETE, preferredStyle: .alert)
            
            // cancel
            alertView.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (alertAction) -> Void in
                print("onTouchButtonDelete : いいえ")
            }))
            
            // OK
            alertView.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (alertAction) -> Void in
                print("onTouchButtonDelete : はい")
                self.deleteMail()
                
            }))
            
            // show alert
            present(alertView, animated: true, completion: nil)
            
            
        }else {
            let alertView = UIAlertView()
            alertView.tag = 20
            alertView.title = ""
            alertView.message = MESSAGE_MAIL_DELETE
            alertView.delegate = self
            alertView.addButton(withTitle: cancelTitle)
            alertView.addButton(withTitle: okTitle)
            alertView.show()
        }
    }
    
    // MARK: - UIWebViewDelegate
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(request.url!)
            return false
        }
        
        return true
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        self.activityIndicator.isHidden = true
        
        // enable zoom with scalesPageToFit = false
       
        let enableJs = "var meta = document.createElement('meta'); meta.setAttribute( 'name', 'viewport' ); meta.setAttribute( 'content', 'width = device-width, initial-scale=1.0, minimum-scale=0.2, maximum-scale=5.0; user-scalable=1;' ); document.getElementsByTagName('head')[0].appendChild(meta)";
        self.webViewContent.stringByEvaluatingJavaScript(from: enableJs)
 
    }
    func loadHtmlBody() {
        self.activityIndicator.isHidden = false
        if var messageDescription = self.mailInfo?.messageDescription {
            
            messageDescription = messageDescription.replacingOccurrences(of: "\n", with: "<br>")
            
            self.webViewContent.loadHTMLString(messageDescription, baseURL: nil)
            self.webViewContent.scalesPageToFit = false
        } else {
            self.activityIndicator.isHidden = true
        }
        
        /*
         * taopd comment
         if let mailId = self.mailInfo?.mail_id, idInt = Int(mailId) {
         PostalMachine.loadMessage(idInt, beaconInfo: self.beaconInfo, geofence: self.geofence, complete: { [weak self] (result, success) in
         if let result = result where result.count > 0 {
         let mail = result[0]
         self?.mailInfo!.message = mail.message != "" ? mail.message: mail.messageDescription
         self?.mailInfo!.is_read = true
         MailBox.updateMailContent((self?.mailInfo!)!, fromFavorite: (self?.isFromListMailFavorite)!)
         self?.webViewContent.loadHTMLString((self?.mailInfo?.message)!, baseURL: nil)
         self?.webViewContent.scalesPageToFit = false
         } else {
         if let messageDescription = self?.mailInfo?.messageDescription {
         self?.webViewContent.loadHTMLString(messageDescription, baseURL: nil)
         self?.webViewContent.scalesPageToFit = false
         }
         }
         })
         }
         */
    }
    
    func backToView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK : UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 0
        {
            
        }else if buttonIndex == 1 {
            // DELETE
            if alertView.tag == 20
            {
                
                // Delete
                self.deleteMail()
            }else // Add favorite
            {
                
                // Add favorite
                self.addFavorite()
                
            }
            
        }
    }
    
    func addFavorite() {
        // add mail to favorite db
        self.addMailToFavorite([self.mailInfo!])
        
        // delele mails(200)
        MailBox.optimizeMemory(self.beaconInfo, geo: nil, applyForFavorite: true)
        
        // show toast
        self.showToast("mail_add_favorite_toast".localizedString)
        
        // hidden button add favorite
        self.buttonAddFavorite.isHidden = true
    }
    
    func deleteMail() {
        // delete mail from db
        self.deleteMail([self.mailInfo!],fromFavorite:self.isFromListMailFavorite)
        // show toast
        self.showToast("mail_delete_mail_toast".localizedString)
        
        // back
        var _ = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(MessageDetailViewController.backToView), userInfo: nil, repeats: false)
        
        
    }
    
    func share() {
        if  let message = self.mailInfo?.message {
            let objectsToShare = ShareInfo()
            objectsToShare.title = (self.mailInfo?.subject)!
            objectsToShare.content = message
            
            let activityVC = UIActivityViewController(activityItems: [objectsToShare,URL_HOMEPAGE], applicationActivities: nil)
            
            // iphone
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
            {
                self.present(activityVC, animated: true, completion: nil)
            }else // ipad
            {
                let popoverCntlr = UIPopoverController(contentViewController: activityVC)
                popoverCntlr.present(from: CGRect(x: self.view.frame.size.width, y: 70, width: 0, height: 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.up, animated: true)
            }
            
        }
        
    }
    
}
