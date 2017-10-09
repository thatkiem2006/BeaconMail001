//
//  UIImageView+.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImageWithURL(_ imageUrl: URL?){
        if let url = imageUrl {
            self.sd_setImage(with: url)
        }
    }
}
