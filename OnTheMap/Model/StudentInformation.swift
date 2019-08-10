//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 26/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import Foundation
//Mark: here is the Students Information session Request as an array
struct StudentsInformation : Codable {
    
    let results : [StudentInformation]?
}

//Mark: here is the Students Information session Request for the singel student
struct StudentPostInformation : Codable {
    let result : StudentInformation?
}

//Mark: here is the detailed of the singel student information Request

struct StudentInformation : Codable {
    
    let createdAt : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    let objectId : String?
    let uniqueKey : String?
    let updatedAt : String?
    
}

//Mark: here is the detailed if the post new student location and link Request
struct StudentPostJesonBody: Codable{
    let uniqueKey : String?
    let firstName : String?
    let lastName : String?
    let latitude : Double?
    let longitude : Double?
    let mapString : String?
    let mediaURL : String?
    
}
//here is the  Student Information Response
struct StudentInformationResponse : Codable {
    let createdAt : String?
    let objectId : String?
    
}

