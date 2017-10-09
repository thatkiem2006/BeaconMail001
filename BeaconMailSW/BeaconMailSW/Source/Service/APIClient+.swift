//
//  APIClient+.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyXMLParser
import Alamofire

extension APIClient {
    
    func sendUUIDToServer(_ beaconInfo:BeaconInfo, completionHandler: ((ResponseObject?) -> Void)!){
        let major = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.major)!))
        let minor = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.minor)!))
        let majorminor =  String(format: "%@%@", major, minor)
        
        let idfv = DeviceInfo.getUUID().replacingOccurrences(of: "-", with: "")
        let uuid = beaconInfo.uuid.replacingOccurrences(of: "-", with: "")
        let url = "\(URL_SEND_UUID)\(uuid)\(majorminor)\(idfv)"
        //fix  error
        
//        let dataTask = self.sessionManager.get(url, parameters: nil, success: {
//            (task:URLSessionDataTask!, responseObject:AnyObject!) -> Void in
//            self.analyzeTask(task,responseObject:responseObject, block: completionHandler)
//        }) { (task:URLSessionDataTask!, error:NSError!) -> Void in
//            self.analyzeTask(task,responseObject:nil, block: completionHandler)
//        }
        
        
        
//        dataTask.resume()
    }
    
    func getNearGeofence(_ lat: Double, lon: Double, completionHandler: ((ResponseObject?) -> Void)?) {
        
        let urlString = BASE_URL + "?latitude=\(lat)&longtitude=\(lon)"
        self.GET(urlString, parameters: nil, completionHandler: completionHandler)
    }
    
    func requestGetConfigXMLFile(_ complete: @escaping ((ConfigurationBean?) -> Void)) {
        let urlString = AppConfig.xml_url_configuration
        
        print("requestGetConfigXMLFile")
        
        Alamofire.request(urlString).responseData { (response) in
            if response.error == nil {
                print(response.result)
                
                // Show the downloaded image:
                if response.data != nil {
                    
                    print("Save XML Config beacon & geo fence")
                    
                    let data = response.data
                    let config = ConfigurationBean.parseFrom(data)
                    
                    
                    if let geoBundle = config?.geofenceList {
                        geoBundle.map({ (geo) in
                            Geofence.insert(geo)
                        })
                    }
                    
                    ConfigurationBean.writeToFile(data)
                    
                    complete(config)
                }
            } else {
//                  UDSet(KEY_DOWNLOAD_CONFIG_SUCCESS, bool: false)
            }
        }
  
    }
    
    func downloadFile(completionHandler:@escaping (AnyObject?) -> ()) {
        
        print("downloadFile configuration.xml")
        
        let requestURL: NSURL = NSURL(string: "https://idio.sakura.ne.jp/bm3/01C4D1300D37D1AD07A961/configuration.xml")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) { data, response, error in
            
            // check for fundamental networking errors
            
            guard error == nil && data != nil else {
                
                completionHandler(nil)
                return
            }
            
            // check to see if status code found, and if so, that it's 200
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completionHandler(nil)
                return
            }
            
            do {
                //let json = try JSONSerialization.jsonObject(with: data!, options:[])
                completionHandler(data as AnyObject)
            } catch let parseError as NSError {
                print("Error with Json: \(parseError)")
                completionHandler(nil)
            }
        }
        
        task.resume()
    }

    func requestGetGeoFenceXMLFile(_ geo: GeoFenceBean, complete: @escaping (_ xmlParserError: Bool, GeoFenceBean?) -> Void) {
       
        guard let url = parseURLFromGeoFence(geo) else{
            complete(false, nil)
            return
        }
 
        
       // let url = "https://idio.sakura.ne.jp/bm3/01C4D1300D37D1AD07A961/0140e007/064e126e.xml"
        
        self.GET(url, parameters: nil, responseSerializer: AFHTTPResponseSerializer()) { (response) in
            if response?.requestResult == .success {
                guard let data = response?.data as? Data else{
                    complete(false, nil)
                    return
                }
                
                //taopd
                let xml = try! XML.parse(data)
                let root = xml["data"]
                
                if root.all == nil {
                    complete(true, nil)
                    return
                }
//                
//                let geoF = GeoFenceBean(geo: geo)
//                geoF.xmlData = data
                
                geo.xmlData = data
                DispatchQueue.main.async(execute: {
                    complete(false, geo)
                })
                
            }else {
                complete(false, nil)
            }
        }
    }
    
    func requestGetiBeaconXMLFile(_ beaconInfo:BeaconInfo, complete: @escaping (_ xmlParserError: Bool, BeaconInfo?) -> Void) {
        guard let url = parseURLFromiBeacon(beaconInfo) else{
            complete(false, nil)
            return
        }
        self.GET(url, parameters: nil, responseSerializer: AFHTTPResponseSerializer()) { (response) in
            if response?.requestResult == .success {
                guard let data = response?.data as? Data else{
                    complete(false, nil)
                    return
                }
                
                //taopd
                let xml = try! XML.parse(data)
                let root = xml["data"]
                
                if root.all == nil {
                    complete(true, nil)
                    return
                }
                
                let ibeacon = BeaconInfo(beacon: beaconInfo)
                ibeacon.xmlData = data
                complete(false, ibeacon)
            }else {
                complete(false, nil)
            }
        }
    }
    
    fileprivate func parseURLFromiBeacon(_ beaconInfo: BeaconInfo) -> String?{
        var baseUrlXml = ""
        var beaconList = StaticData.shared.bmConfiguration?.ibeaconList
        if beaconList == nil {
            ConfigurationBean.loadLocal({ (success, data) in
                beaconList = data?.ibeaconList
            })
        }
        if let beaconList = beaconList {
            beaconList.map({ (beacon) in
                if beaconInfo.uuid == beacon.uuid, let url =  beacon.xmlUrl{
                    baseUrlXml = url
                }
            })
        }
        let major = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.major)!))
        let minor = Common.converStringTo4Digit(Common.convertIntToHex(Int(beaconInfo.minor)!))
        let majorminor =  String(format: "%@/%@.xml", major, minor)
        let url = baseUrlXml + "/" + majorminor
        return url
    }
    
    fileprivate func parseURLFromGeoFence(_ geo: GeoFenceBean) -> String?{
        guard let geoBaseURL = StaticData.shared.bmConfiguration?.xmlUrlForGf else {
            return nil
        }
        
        if geo.xmlID == nil {
            return ""
        }
        
        let urlString = "\(geoBaseURL)/\(geo.xmlID!).xml"
        print("parseURLFromGeoFence:\(urlString)")
        
        return urlString
    }
}

