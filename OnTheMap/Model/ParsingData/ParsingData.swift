//
//  APIClass.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 24/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//


import Foundation

// MARK: class ParsingData : NSObject
class ParsingData : NSObject  {
   
    // I see this https://github.com/stenpety/udacity-On-The-Map project and get inspired with whenever I stuck in getting an idea of  something
    // MARK: Properties
    
    // The shared session
    var session = URLSession.shared
    
    
    // authenticatin importent variables to be set
    var sessionID : String? = nil
    var userID : String? = nil
    var userName : String? = nil
    var firstName : String? = nil
    var lastName : String? = nil
    
    
    
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    
    // MARK: Methods
    
    //// MARK: Utilizing Methods
    
    //MARK: creatURL : methods that deal with the repeated creating of urls during the session
    // func creatURL(apiHost: String, apiPath: String,  apiExtension: String?, apiparameters: [String:String]?)
    func creatURL(apiHost: String, apiPath: String,  apiExtension: String?, apiparameters: [String:String]?) -> URL {
        //create and set urL components
        var urLcomponents = URLComponents()
        urLcomponents.scheme = Constants.ApiScheme
        urLcomponents.host = apiHost
        urLcomponents.path = apiPath + (apiExtension ?? "")
        urLcomponents.queryItems = [URLQueryItem]()
        
        if let parameters = apiparameters {
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: value)
                urLcomponents.queryItems!.append(queryItem)
            }
        }
        //retrun the created url urLcomponents
        return urLcomponents.url!
    }
    
    // Make SharedPoint() Instance
    class func SharedPoint() -> ParsingData {
        struct SharedPoint {
            static var sharedInstance = ParsingData()
        }
        return SharedPoint.sharedInstance
    }
    
    
    //MARK:Genaric codable type methods for Get,Post ,and Delete requests
    
    
    //MARK: the getRequestMehod : responsible for all THE GET Request in the app
    // MARK: taskForGETRequest<ResponseType: Decodable>(withURL url: URL, decode:ResponseType.Type, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask
    
    func  taskForGETRequest<ResponseType: Decodable>(withURL url: URL, ResponseType:ResponseType.Type, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //defined the error " to getthe error message
        func defindError(_ error: String) {
            print(error)
            let message = [NSLocalizedDescriptionKey : error]
            completion(nil, NSError(domain: "taskForGETRequest", code: 1, userInfo: message))
        }
        
        // configure the url with the use of  NSMutableURLRequest to mutate the request object for a series of URL load requests
        let request = NSMutableURLRequest(url: url)
        
        // because there is an extra feilds in the regular url -parse.udacity.com - (not the authentecation path)
        //check url and add the fields , add request Values
        
        if url.description.contains("parse.udacity.com") {
            request.addValue(ParsingData.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParsingData.Constants.ApiKey , forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        
        //  lets start the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            //  GUARD: check errors
            guard (error == nil) else {
                defindError("\(error!.localizedDescription)")
                return
            }
            
            // GUARD:  check if the request was successful
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                switch statusCode {
                    
                case 403 : defindError("Email or Password are not correct!")
                case 404 : defindError("Not found")
                default : defindError("Not successful request: \(statusCode)")
                }
                    
            }
              defindError("Not successful request")
                return
            }
            
            // GUARD:  is there a succesful data returned from the request
            guard let data = data else {
                defindError("No data returned!")
                return
            }
            
            // set the successful returned data
            var  newdata = data
            
            //because there is an a feilds  in the regular url -onthemap-api.udacity.com - need to be cutted from the response, so that why there will be a check statment and also manipulation
            if url.description.contains("onthemap-api.udacity.com") {
                let range = Range(5 ..< data.count)
                newdata = data.subdata(in: range)
            }
            
            // parse the data
            do {
                let response = try JSONDecoder().decode(ResponseType, from: newdata)
                
                completion(response as ResponseType as AnyObject, nil)
                
            } catch {
                let message = [NSLocalizedDescriptionKey : "Could not parse the data: '\(data)'"]
                completion(nil, NSError(domain: "", code: 1, userInfo: message))
            }
        }
        
        
        task.resume()
        
        return task
        
    }
    
    
    //MARK: taskForPOSTRequest: responsible for all THE POST Request in the app
    // MARK: taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(withURL url: URL, responseType: ResponseType.Type?, body: RequestType, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask
    func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(withURL url: URL, responseType: ResponseType.Type?, body: RequestType, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //defined the error " to getthe error message
        func defindError(_ error: String) {
            print(error)
            let message = [NSLocalizedDescriptionKey : error]
            completion(nil, NSError(domain: "taskForPOSTRequest", code: 1, userInfo: message))
        }
        
        // configure the url with the use of  NSMutableURLRequest to mutate the request object for a series of URL load requests
        let request = NSMutableURLRequest(url: url)
        
        // because there is an extra feilds in the regular url -parse.udacity.com - (not the authentecation path)
        //check url and, add request Values
        if url.description.contains("parse.udacity.com") {
            
            request.addValue(ParsingData.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(ParsingData.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        }
        //set request Values, and method Type" POST "
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // covert the request data to json
        do{
            let jsonbody = try JSONEncoder().encode(body)
            request.httpBody = jsonbody
            
        } catch{
            defindError("There was an error with the request !")
        }
        
        //  lets start the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //  GUARD: check errors
            guard (error == nil) else {
                defindError("\(error!.localizedDescription)")
                return
            }
            
            // GUARD:  check if the request was successful
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    switch statusCode {
                        
                    case 403 : defindError("Email or Password are not correct!")
                    case 404 : defindError("Not found")
                    default : defindError("Not successful request: \(statusCode)")
                    }
                    
                }
                defindError("Not successful request")
                return
            }
            
            // GUARD:  is there a succesful data returned from the request
            guard let data = data else {
                defindError("NO returned data from request")
                return
            }
            var  newdata = data
            
            //because there is an a feilds  in the regular url -onthemap-api.udacity.com - need to be cutted from the response, so that why there will be a check statment and also manipulation
            
            if url.description.contains("onthemap-api.udacity.com") {
                //Remove 5 checter from Response
                let range = 5..<data.count
                newdata = data.subdata(in: range) /* subset response data! */
            }
            
            
            // parse the data
            
            do {
                let response = try JSONDecoder().decode(responseType!, from: newdata)
                
                completion( response as AnyObject , nil)
                
            } catch {
                let message = [NSLocalizedDescriptionKey : "Could not parse the data! : '\(data)'"]
                completion(nil, NSError(domain: "", code: 1, userInfo: message))
                
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    
    // taskForDeleteMethod: responsible for all THE POST Request in the app
    //func taskForDeleteMethod<ResponseType:Decodable>(withURL url: URL, _ decode :ResponseType.Type?, completionHandlerForDelete: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)
    func taskForDeleteMethod<ResponseType:Decodable>(withURL url: URL, _ responseType :ResponseType.Type?, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        //defined the error " to getthe error message
        func defindError(_ error: String) {
            print(error)
            let message = [NSLocalizedDescriptionKey : error]
            completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: message))
        }
        // configure the url with the use of  NSMutableURLRequest to mutate the request object for a series of URL load requests
        let request = NSMutableURLRequest(url:url)
        //set request Values, and method Type "DELETE"
        request.httpMethod = "DELETE"
        
        //deiling with the Cookies and so on
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        //  lets start the request
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if error != nil { // Handle error…
                defindError("\(error!.localizedDescription)")
                return
            }
            
            //cut response
            let range = Range(5..<data!.count)
            let newdata = data?.subdata(in: range)
            
            
            // parse the data
            do {
                let response = try JSONDecoder().decode((ResponseType.self), from: newdata!)
                
                completion(response as AnyObject, nil)
                
            } catch {
                let message = [NSLocalizedDescriptionKey : "Could not parse the data! : '\(String(describing: data))'"]
                completion(nil, NSError(domain: "", code: 1, userInfo: message))
            }
        }
        
        
        task.resume()
        
        return task
    }
    
}

