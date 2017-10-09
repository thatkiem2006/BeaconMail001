//
//  Foundation.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation

extension UIImage {
    static func bmImage(_ named: String) -> UIImage? {
        let bundle = Bundle(for: BeaconMail.self)
        return UIImage(named: named, in: bundle, compatibleWith: nil)
    }
}
