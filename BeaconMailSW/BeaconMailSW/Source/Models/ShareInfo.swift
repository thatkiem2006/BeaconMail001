//
//  ShareInfo.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class ShareInfo: NSObject,UIActivityItemSource {
    var title: String = ""
    var content: String = ""
    var url : String = ""
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        //        print("Place holder")
        
        return title;
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        //        print("Place holder itemForActivity")
        
        if(activityType == UIActivityType.mail){
            return "<html>\(content) </html>"
        }
        
        return title
        
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivityType?) -> String {
        //        print("Place holder subjectForActivity")
        
        return title
    }
}
