//
//  BCMailManager.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation
import Postal
class BCMailManager {
    func load(){
        let filter = .subject(value: "Foobar") && .from(value: "foo@bar.com")
        let postal = Postal(configuration: .icloud(login: "myemail@icloud.com", password: "mypassword"))
        postal.connect { result in
            
        }
    }
}
