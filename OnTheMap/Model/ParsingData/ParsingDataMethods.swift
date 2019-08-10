//
//  ParsingDataMethods.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 31/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import Foundation

// MARK: extension ParsingData
extension ParsingData{
    
    
    // MARK:  user uthentication method
    // MARK:  func userUuthentication <ResponseType: Encodable>(jsonBody: ResponseType, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void)
    func userUuthentication <ResponseType: Encodable>(jsonBody: ResponseType, completion: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        
        //set the url using creatURL method
        let url = ParsingData.SharedPoint().creatURL(apiHost: ParsingData.Constants.UApiHost , apiPath: ParsingData.Constants.UApiPath, apiExtension: ParsingData.Methods.AuthenticationSession, apiparameters: nil)
        
        //with the use of the created url there will be call to posting Session using postingASession function
        self.postingASession(withURL: url, jsonBody: jsonBody) { (success, sessionID,userID, errorString) in
            if success {
                
                // that mean we have set  session id and account key ,so lets set them to the class variables to use them later on (:
                self.sessionID = sessionID
                self.userID = userID
                
                // now lets get the user dat like name using the accoun key that we get before and by calling gettingPublicUserData  method
                
                self.gettingPublicUserData(userID: userID) { (success, firstName,lastName, errorString) in
                    
                    if success {
                        //then set name
                        if let firstName = firstName, let lastName = lastName {
                            self.firstName = firstName
                            self.lastName = lastName
                            self.userName = "\(firstName) \(lastName)"
                        }
                        
                    }
                    completion(success, errorString)
                }
            } else {
                
                completion(success, errorString)
            }
        }
    }
    
    
    // MARK: posting A Session : Verification user and give the authenticity key
    //  func postingASession<ResponseType: Encodable>( withURL url: URL,jsonBody: ResponseType ,completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?,_ userID: String?, _ errorString: String?) -> Void)
    func postingASession<ResponseType: Encodable>( withURL url: URL,jsonBody: ResponseType ,completion: @escaping (_ success: Bool , _ sessionID: String?,_ userID: String?, _ errorString: String?) -> Void) {
        
        //start with taskForPOSTRequest method using the sended url and also with providing the  choosen ResponseType
        _ = taskForPOSTRequest( withURL: url, responseType: USessionResponse.self, body: jsonBody) { (result, error) in
            
            //check errors
            if let error = error {
                completion(false ,nil ,nil," \(error.localizedDescription) ")
            }
            else {
                //check result  as! USessionResponse
                let newresult = result as! USessionResponse
                
                //check the 2 importent respnses ession id and account key are exicte
                if let sessionID = newresult.session.id , let userID = newresult.account.key  {
                    completion(true ,sessionID,userID ,nil)
                    
                }else {
                    completion(false ,nil ,nil," \(error!.localizedDescription)")
                    
                }
                
            }
        }
        
    }
    
    
    // MARK: getting student name using account key
    // func gettingPublicUserData(userID: String?,_ completionHandlerForUserID: @escaping (_ success: Bool,_ firstName: String?,_ lastName: String?, _ errorString: String?) -> Void)
    func gettingPublicUserData(userID: String?,_ completion: @escaping (_ success: Bool,_ firstName: String?,_ lastName: String?, _ errorString: String?) -> Void) {
        
        // now we we will replace the (id) word with the unique id that we set before to create the url
        var request :String = Methods.GetPublicDataForUserID
        if (request.range(of: "{\(ParsingData.URLKeys.UserID)}") != nil){
            request =  request.replacingOccurrences(of: "(\(ParsingData.SharedPoint().userID!)))", with: userID!)
            
        }
        
        let url = ParsingData.SharedPoint().creatURL(apiHost: ParsingData.Constants.UApiHost , apiPath: ParsingData.Constants.UApiPath, apiExtension: request, apiparameters: nil)
        
        
        //start the get request by calling taskForGETRequest with the replaced url and the response type
        _ = taskForGETRequest(withURL: url, ResponseType: Uusername.self) { (result, error) in
            
            //check errors and handel it
            if let error = error {
                
                completion(false ,nil,nil ,"\(error.localizedDescription)")
            }
            else {
                //check result and return name variables
                let newresult = result as! Uusername
                if let firstName = newresult.first_name, let lastName = newresult.last_name {
                    
                    completion(true ,firstName,lastName,nil)
                    
                }else {
                    completion(false ,nil,nil,"\(String(describing: error?.localizedDescription))")
                    
                }
                
                
            }
        }
        
    }
    
    
    // MARK: getting all students location
    // func gettingStudentLocations (  completionHandlerForgettingStudentLocations: @escaping (_ success: Bool,_  studentLocations : [Any]?, _ errorString: String?) -> Void)
    func gettingStudentLocations (  completion: @escaping (_ success: Bool,_  studentLocations : [Any]?, _ errorString: String?) -> Void){
        //this url will be more specific cuz it has a parameters to be sets
        let urlParameters =  [ParsingData.ParameterKeys.Limit: ParsingData.ParameterValues.Limit, ParsingData.ParameterKeys.Order: ParsingData.ParameterValues.Order]
        
        //with the use of the created url with setting urlParameters
        let url = ParsingData.SharedPoint().creatURL(apiHost: ParsingData.Constants.ApiHost , apiPath: ParsingData.Constants.ApiPath, apiExtension: ParsingData.Methods.StudentLocation, apiparameters: urlParameters)
        
        
        // start a get reques usig taskForGETRequest
        
        _ = taskForGETRequest( withURL: url , ResponseType: StudentsInformation.self) { (result, error) in
            
            //check errors
            if let error = error {
                
                completion(false ,nil ,"\(error.localizedDescription)")
            }else {
                //check result and return studentLocations array
                let newresult = result as! StudentsInformation
                if let studentLocations = newresult.results  {
                    
                    completion(true ,studentLocations,nil)
                    
                }else {
                    completion(false ,nil ,"\( error!.localizedDescription)")
                }
            }
            
        }
    }
    
    
    // MARK: post Student Location to the server
    //  func postStudentLocation <RequestType: Encodable>( jsonBody:RequestType,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void)
    func postStudentLocation <RequestType: Encodable>( jsonBody:RequestType,completion: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        //set the url using creatURL method
        let url = ParsingData.SharedPoint().creatURL(apiHost: ParsingData.Constants.ApiHost , apiPath: ParsingData.Constants.ApiPath, apiExtension: Methods.StudentLocation, apiparameters: nil)
        
        
        // start a get reques usig taskForPOSTReques with encoded type response
        
        _ = taskForPOSTRequest(withURL : url, responseType: StudentInformationResponse.self, body: jsonBody) { (result, error) in
            //check errors
            if let error = error {
                completion(false ,"\(error.localizedDescription) ")
            }else {
                //check if StudentInformationResponse are not nil
                if result != nil{
                    completion(true ,nil)
                    
                }else {
                    completion(false ," \(error!.localizedDescription)")
                    
                }
            }
        }
        
    }
    
    
    // MARK: deleitingin A Session
    //  func deleitinginASession(_ completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?, _ errorString: String?) -> Void)
    func deleitinginASession(_ completion: @escaping (_ success: Bool , _ sessionID: String?, _ errorString: String?) -> Void) {
        
        //set the url using creatURL method
        let url = ParsingData.SharedPoint().creatURL(apiHost: ParsingData.Constants.UApiHost , apiPath: ParsingData.Constants.UApiPath, apiExtension: Methods.AuthenticationSession, apiparameters: nil)
        
        //start deleting request by calling taskForDeleteMethod
        _ = taskForDeleteMethod(withURL : url, SessionObject.self, completion: { (result, error) in
            //check error
            if let error = error {
                completion(false ,nil,"\(error.localizedDescription) ")
            }else {
                //check result as  SessionObject
                let newresult = result as! SessionObject
                if let sessionID = newresult.session.id  {
                    //return sessionID
                    completion(true ,sessionID ,nil)
                    
                }else {
                    completion(false ,nil ," \(error!.localizedDescription)")
                }
                
            }
        }
        )
    }
}






