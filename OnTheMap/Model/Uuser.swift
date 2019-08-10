//
//  Uuser.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 29/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import Foundation

//Mark: here is the udacity user authentcation session Request
struct UuserSessionBody : Codable {
    let udacity: Uuser
}

struct Uuser : Codable {
    let username:String
    let password:String
}

///Mark: here is the udacity user authentcation session Response

struct USessionResponse : Codable {
    let account : Account
    let session : Session
    
}

struct Account : Codable {
    let registered : Bool?
    let key : String?
}

struct SessionObject: Codable {
    let session : Session
}

struct Session : Codable {
    let id : String?
    let expiration : String?
}

//Mark: here will be the first and last name -
//(they will be gets and sets right after the authencation process Succeed )

struct Uusername: Codable {
    let first_name : String?
    let last_name : String?
    
}


//Mark: here will be the class of shared store array of all StudentsInformation needed information on the app which will be used in the (Map and tabel controllers later!)
class UuserDataArray {
    static let shared = UuserDataArray()
    
    var studentDataArray = [Any?]()
    
    private init() { }
}




