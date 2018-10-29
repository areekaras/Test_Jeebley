//
//  Service.swift
//  Test_Jeebley
//
//  Created by Shibili Areekara on 26/10/18.
//  Copyright © 2018 Shibili Areekara. All rights reserved.
//

import Foundation

private var _url : String = ""
private var _statusCode : Int = 0
private var _httpStatusCode:Int?
private var _timeOutInterval: Int = 60
private var _allowCelllarAccess:Bool = true
var _requestMethod:String = "GET"


open class Service :NSObject  {
	
	open class var timeOutInterval : Int {
		get {return _timeOutInterval}
		set {_timeOutInterval = newValue}
	}
	
	open class var allowCellularAccess : Bool {
		get {return _allowCelllarAccess}
		set {_allowCelllarAccess = newValue}
	}
    
    open func setConfigUrl(_ value:String) {
        _url = value;
    }

    open func requestMethod(_ value:String) {
        _requestMethod = value
    }
    
    func execute(_ completion:@escaping (_ data:NSObject,_ action:String,_ serviceStatus:String) -> Void) {
        
        guard let myUrl:URL = URL(string: _url) else { return }
        
        let session = URLSession(configuration : sessionConfiguration())
        let request = NSMutableURLRequest(url: myUrl)
        request.httpMethod = _requestMethod
		request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		
		
        let task = session.dataTask(with: request as URLRequest){
        (data, response, error) in
            if  error != nil {
                print("error ==\(String(describing:  error?.localizedDescription))")
                completion((error?.localizedDescription)! as NSObject, (error?.localizedDescription)!,"failed")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                _httpStatusCode = httpResponse.statusCode
                print(_httpStatusCode!)
                let responseString1 = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(responseString1!)
                if (_httpStatusCode == 200) {
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print(responseString!)
                    do {
                        let service_result = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        let result:NSDictionary  = (service_result.value(forKey: "result") as? NSDictionary)!
                        let statusMessage:String? = result.value(forKey: "status_message") as? String
                        let serviceStatus:String? = result.value(forKey: "status") as? String
                        let action:String = (result.value(forKey: "action") as? String)!
                        
//                        switch serviceStatus! {
//                            case ServiceResultEnum.SUCCESS.rawValue:
//                                let data  = (result["data"] as? NSObject)!
//                                if(action == ServiceEnum.GET_ALL_MODULES_LIST.rawValue){
//                                    completion(result,action,serviceStatus!)
//                                }
//                                else{
//                                    completion(data, action, serviceStatus!)
//                                }
//                                break
//                            case ServiceResultEnum.FAILED.rawValue:
//                                completion(statusMessage! as NSObject, action, serviceStatus!)
//                            break
//                            case ServiceResultEnum.DUPLICATE_LOGIN.rawValue:
//                                completion(statusMessage! as NSObject, action, serviceStatus!)
//                                break
//                            default : ()
//                        }
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                         completion("Service Error" as NSObject, "Service Error", "failed")
                    }
                }
                else  if (_httpStatusCode == 500 )
                {
                    completion("Service Error" as NSObject, "Service Error", "failed")
                }
                else  {
                    do {
                        let service_result = try JSONSerialization.jsonObject(with: data!, options: []) as! NSDictionary
                        let result:NSDictionary  = (service_result.value(forKey: "result") as? NSDictionary)!
                        let statusMessage:String? = result.value(forKey: "status_message") as? String
                        let action:String = (result.value(forKey: "action") as? String)!
                        let serviceStatus:String? = result.value(forKey: "status") as? String
                        completion(statusMessage! as NSObject, action,serviceStatus!)
                    }
                    catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                         completion("Service Error" as NSObject, "Service Error", "failed")
                    }
                }

            }
        }
        task.resume()
    }


	fileprivate func sessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.allowsCellularAccess = _allowCelllarAccess
		configuration.timeoutIntervalForRequest = TimeInterval(_timeOutInterval)
		configuration.timeoutIntervalForResource = 60
		return configuration
	}
	
}




