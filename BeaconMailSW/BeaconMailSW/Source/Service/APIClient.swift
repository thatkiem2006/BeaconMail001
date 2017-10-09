//
//  APIClient.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import AFNetworking

// ENUM
enum RequestResult
{
    case success
    case error
    case time_OUT
    case no_CONNECTION
}

// STRUCT
struct ResponseCode
{
    let kHTTPResponseCodeSuccess:Int = 200
    let kHTTPResponseCodeBadRequest:Int = 400
    let kHTTPResponseCodeForbidden:Int = 403
    let kHTTPResponseCodeNotFound:Int = 404
    let kHTTPResponseCodeRequestTimeout:Int = 408
}

// CLASS
class ResponseObject {
    var data:AnyObject!
    var requestResult:RequestResult = .success
}

// APIClient
class APIClient: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate  {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            debugPrint("Progress \(downloadTask) \(progress)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        debugPrint("Download finished: \(location)")
        try? FileManager.default.removeItem(at: location)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        debugPrint("Task completed: \(task), error: \(error)")
    }
    // session manager
    var sessionManager:AFHTTPSessionManager!
    let responseSerializerDefault = AFJSONResponseSerializer(readingOptions: JSONSerialization.ReadingOptions(rawValue: 0))
    // shared instance
    var downloadTask: URLSessionDownloadTask!
    var backgroundSession: URLSession!
    
    class var shared : APIClient {
        struct Static {
            static let instance : APIClient = APIClient()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        // check network
        AFNetworkReachabilityManager.shared().startMonitoring()
        
        // session Manager
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30.0;
        configuration.timeoutIntervalForResource = 60.0;
        self.sessionManager = AFHTTPSessionManager(baseURL: URL(string: BASE_URL), sessionConfiguration: configuration)
    }
    
    // analyze reponse task
    func analyzeTask(_ task:URLSessionDataTask!,responseObject: AnyObject!,block: ((ResponseObject?) -> Void)!)
    {
        
        // check connection
        if self.isConnectedInternet() == false
        {
            self.handleError(.no_CONNECTION,block:block)
            return
        }
        
        if task.response == nil
        {
            self.handleError(.error,block:block)
            return
        }
        
        let httpResponse:HTTPURLResponse =  task.response as! HTTPURLResponse
        let statusCode:Int = httpResponse.statusCode
        print("RESPONSE CODE : \(statusCode)")
        
        // if responseObject is nil, error
        if responseObject == nil
            || task == nil
        {
            self.handleError(.error,block:block)
            return
        }
        
        // check response code
        if statusCode == ResponseCode().kHTTPResponseCodeSuccess
        {
            self.handleSuccess(responseObject,block: block)
            
        }else if statusCode == ResponseCode().kHTTPResponseCodeRequestTimeout
        {
            self.handleError(.time_OUT,block:block)
            
        }else{
            self.handleError(.error,block:block)
        }
    }
    
    
    // SUCCESS
    func handleSuccess(_ responseObject: AnyObject!,block: ((ResponseObject?) -> Void)!) {
        let resposeObject:ResponseObject = ResponseObject()
        resposeObject.requestResult = .success
        resposeObject.data = responseObject
        block(resposeObject)
    }
    
    // ERROR
    func handleError(_ requestResult:RequestResult,block: ((ResponseObject?) -> Void)!) {
        // response object
        let resposeObject:ResponseObject = ResponseObject()
        resposeObject.requestResult = requestResult
        block(resposeObject)
        
    }
    
    // show alert
    static func showAlertError(_ requestResult:RequestResult,delegate:AnyObject?, tag:NSInteger)
    {
        var message = ""
        var cancelButtonTitle = "button_ok".localizedString
        
        if delegate != nil
        {
            cancelButtonTitle = "button_retry".localizedString
        }
        
        switch requestResult {
        case .time_OUT:
            message = "connect_timeout".localizedString
            
            break
        case .no_CONNECTION:
            message = "network_error".localizedString
            break
        case .error:
            message = "server_error".localizedString
            break
        default:
            break
            
        }
        
        // show alert
        let alert = UIAlertView(title: "", message:message, delegate: delegate, cancelButtonTitle:cancelButtonTitle)
        alert.tag = tag
        alert.show()
    }
    
    // Check connection
    func isConnectedInternet() -> Bool{
        return  AFNetworkReachabilityManager.shared().isReachable
    }
    
    // MARK: - Method
    func POST(_ urlString: String, parameters: AnyObject?,completionHandler: ((ResponseObject?) -> Void)?) {
        self.POST(urlString, parameters: parameters, responseSerializer: nil, completionHandler: completionHandler)
    }
    
    func POST(_ urlString: String, parameters: AnyObject?, responseSerializer: AFHTTPResponseSerializer?,completionHandler: ((ResponseObject?) -> Void)?) {
        if responseSerializer != nil {
            sessionManager.responseSerializer = responseSerializer!
        }else {
            sessionManager.responseSerializer = responseSerializerDefault
        }
        
        //fix error
//        let dataTask =  self.sessionManager.post(urlString, parameters: parameters, success: { (task, responseObject) in self.analyzeTask(task, responseObject: <#T##AnyObject!#>, block: (resp)) {
//            
//        
//        }
        
            
            
//            self.analyzeTask(task, responseObject: responseObject, block: ((resp) -> Void)!, block: )
//            } as! (URLSessionDataTask?, Any?) -> Void) { (task, error) in
//                if error.code == NSURLErrorNetworkConnectionLost {
//                    self.POST(urlString, parameters: parameters, completionHandler: completionHandler)
//                } else {
//                    self.analyzeTask(task, responseObject: nil, block: completionHandler)
//                }
        
 //       dataTask?.resume()
    }
    
    func GET(_ urlString: String, parameters: AnyObject?, completionHandler: ((ResponseObject?) -> Void)?) {
        print("urlString=\(urlString)")
        GET(urlString, parameters: parameters, responseSerializer: nil, completionHandler: completionHandler)
    }
    
    func GET(_ urlString: String, parameters: AnyObject?, responseSerializer: AFHTTPResponseSerializer?, completionHandler: ((ResponseObject?) -> Void)?) {
        print("urlString=\(urlString)")
        if responseSerializer != nil {
            sessionManager.responseSerializer = responseSerializer!
        }else {
            sessionManager.responseSerializer = responseSerializerDefault
        }
        let dataTask = self.sessionManager.get(urlString, parameters: parameters,
             success: { (task, responseObject) in
            self.analyzeTask(task, responseObject: responseObject as AnyObject, block: completionHandler)
        }) { (task, error) in
           // print("GET ERROR: \(error.description)")
            self.analyzeTask(task, responseObject: nil, block: completionHandler)
        }
        dataTask?.resume()
 
 
        /*
 
        let config = URLSessionConfiguration.background(withIdentifier: "com.example.DownloadTaskExample.background")
        let session = URLSession(configuration: config, delegate: self as URLSessionDelegate, delegateQueue: OperationQueue())

        let url = URL(string: urlString)!
        let task = session.downloadTask(with: url)
        task.resume()
        */

    }
}

