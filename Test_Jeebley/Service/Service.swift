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
private var _timeOutInterval: Int = 10
private var _allowCelllarAccess:Bool = true
var _requestMethod:String = RequestMethod.GET.rawValue


/// Service Class to Handle API calls
open class Service :NSObject  {
	
    
    /// Time out for Api call
	open class var timeOutInterval : Int {
		get {return _timeOutInterval}
		set {_timeOutInterval = newValue}
	}
	
    
    /// cellular access
	open class var allowCellularAccess : Bool {
		get {return _allowCelllarAccess}
		set {_allowCelllarAccess = newValue}
	}
    
    /// set url for api call
    ///
    /// - Parameter value: url to set
    open func setConfigUrl(_ value:String) {
        _url = value;
    }

    /// set request method GET POST
    ///
    /// - Parameter value: GET,POST,etc
    open func requestMethod(_ value:String) {
        _requestMethod = value
    }
    
    
    /// execute api call
    ///
    /// - Parameter completion: response from api call
    func execute(_ completion:@escaping (_ data:Data?,_ action:String,_ serviceStatus:String) -> Void) {
        
        guard let myUrl:URL = URL(string: _url) else { return }
        
        let session = URLSession(configuration : sessionConfiguration())
        let request = NSMutableURLRequest(url: myUrl)
        request.httpMethod = _requestMethod
		request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
		
		
        let task = session.dataTask(with: request as URLRequest){
        (data, response, error) in
            if  error != nil {
                print("error ==\(String(describing:  error?.localizedDescription))")
                completion(data, (error?.localizedDescription)!,ServiceStatus.FAILED.rawValue)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                _httpStatusCode = httpResponse.statusCode
                print(_httpStatusCode!)
                if (_httpStatusCode == 200) {
                    completion(data, "",ServiceStatus.SUCCESS.rawValue)
                }
                else  if (_httpStatusCode == 500 )
                {
                    completion(data, ServiceStatus.SERVICE_ERROR.rawValue, ServiceStatus.FAILED.rawValue)
                }
                else  {
                    completion(data, ServiceStatus.ERROR.rawValue, ServiceStatus.FAILED.rawValue)
                }

            }
        }
        task.resume()
    }


    /// set up url session configuration
    ///
    /// - Returns: customised url session
	fileprivate func sessionConfiguration() -> URLSessionConfiguration {
		let configuration = URLSessionConfiguration.default
		configuration.allowsCellularAccess = _allowCelllarAccess
		configuration.timeoutIntervalForRequest = TimeInterval(_timeOutInterval)
		configuration.timeoutIntervalForResource = 10
		return configuration
	}
	
}




