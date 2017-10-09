//
//  Utils.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import Foundation

extension UIViewController {
    func showAlert(withTitle title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

extension String {
    func substring(_ to: Int) -> String {
        guard self.length > to else {
            return self
        }
        
        return self.substring(to: self.characters.index(self.startIndex, offsetBy: to))
    }
    
    var length: Int {
        return self.characters.count
    }
}
//MARK: HELPER
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}
func DLog(infor message: String?) {
    //    BeaconMail.log.info(message)
    print(message ?? "")
}
func DLog(debug message: String?) {
    //    BeaconMail.log.debug(message)
    print(message ?? "")
}
func pathDirectoryDocument() -> String? {
    let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first
    return dir
}
//MARK: FIE MANAGER
func writeToDisk(_ fileName: String, data: Data?, complete:(Bool) -> ()) {
    guard let data = data else{
        return
    }
    if let dir = pathDirectoryDocument() {
        let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName)
        if (try? data.write(to: path, options: [.atomic])) != nil {
            complete(true)
        }else {
            complete(false)
        }
    }
}

func readFileFromDisk(_ fileName: String, complete:(_ success: Bool, _ data: Data?,_ error: String?) ->()) {
    if let dir = pathDirectoryDocument() {
        let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path.path) {
            let data = try? Data(contentsOf: path)
            complete(true, data, nil)
        } else {
            let error = "FILE NOT AVAILABLE"
            complete(false, nil, error)
        }
    }
}
//MARK: USER DEFAULT
func UDSet(_ key: String, object: AnyObject?){
    UserDefaults.standard.set(object, forKey: key)
    UserDefaults.standard.synchronize()
}
func UDSet(_ key: String, value: AnyObject?){
    UserDefaults.standard.setValue(value, forKey: key)
    UserDefaults.standard.synchronize()
}

func UDSet(_ key: String, double: Double){
    UserDefaults.standard.set(double, forKey: key)
    UserDefaults.standard.synchronize()
}

func UDSet(_ key: String, int: Int){
    UserDefaults.standard.set(int, forKey: key)
    UserDefaults.standard.synchronize()
}

func UDSet(_ key: String, bool: Bool){
    UserDefaults.standard.set(bool, forKey: key)
    UserDefaults.standard.synchronize()
}

func UDGet(_ key: String) -> Double {
    return UserDefaults.standard.double(forKey: key)
}

func UDGet(_ key: String) -> Int {
    return UserDefaults.standard.integer(forKey: key)
}

func UDGet(_ key: String) -> AnyObject? {
    return UserDefaults.standard.value(forKey: key) as AnyObject
}

func UDGet(_ key: String) -> String? {
    return UserDefaults.standard.string(forKey: key)
}

func UDGet(_ key: String) -> Bool {
    return UserDefaults.standard.bool(forKey: key)
}


//MARK: OPERAION VIEWCONTROLLER
func getTopViewController() -> UIViewController? {
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
            print(topController.classForCoder)
        }
        return topController
    }
    return nil
    
}

