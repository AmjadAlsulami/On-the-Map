//
//  ParsingDataConstent.swift
//  OnTheMap
//
//  Created by Amjad khalid  on 31/12/2018.
//  Copyright © 2018 Amjad khaled. All rights reserved.
//

import Foundation

// MARK: extension ParsingData
extension ParsingData{
    
    struct Constants {
        
        // MARK: API Keys
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        // MARK: authentcation URL for udacity user
        static let UApiHost = "onthemap-api.udacity.com"
        static let UApiPath = "/v1"
        
    }
    
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
        static let ObjectId = "id"
        
    }
    
    
    // MARK: Parameter Keys
    struct ParameterKeys {
        static let Order = "order"
        static let Limit = "limit"
        static let Where = "where"
        
    }
    
    // MARK: Parameter Values
    struct ParameterValues {
        static let Order = "-updatedAt"
        static let Limit = "100"
        static let Where = "{\"uniqueKey\":\"{id}\"}"
        
        
    }
    
    struct Methods {
        // MARK: StudentLocation method
        static let StudentLocation = "/StudentLocation"
        // MARK: AuthenticationSession
        static let AuthenticationSession = "/session"
        //Mark: get public data by user id
        static let GetPublicDataForUserID = "/users/{id}"
    }
    
    
}

