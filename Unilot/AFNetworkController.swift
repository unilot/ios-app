//
//  AFNetworkController.swift
//  Unilot
//
//  Created by Alyona on 10/14/17.
//  Copyright © 2017 Vovasoft. All rights reserved.
//

import UIKit

let kPOST   =  "POST"
let kGET    =  "GET"
let kPATCH  =  "PATCH"
let kDELETE  =  "DELETE"
let kUPLOAD =  "UPLOAD"
 
var token_session: String?

var session_data = [String: Any]()


class AFNetworkController {
    
    var session_manager  = AFHTTPSessionManager()
    
    var array_of_tasks =  NSMutableArray()
    
    static var updateRequest = false
    
    
    func setHeaders(_ manager : AFHTTPSessionManager) -> AFHTTPSessionManager {
        
        manager.requestSerializer = AFHTTPRequestSerializer()
        
        manager.requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
        
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        manager.securityPolicy.allowInvalidCertificates = false
        
        if token_session != nil {
            manager.requestSerializer.setValue("Bearer " + token_session!,
                                               forHTTPHeaderField: "Authorization")

        
        }
        
        return manager
        
    }
    
    func activeWindwowWillBeClosed(){
        
        /// cancel all previous tasks
        array_of_tasks.enumerateObjects({ object, index, stop in
            if let item = object as? URLSessionDataTask {
                item.cancel()
            }
        })
        
        /// empty the array_of_tasks
        array_of_tasks.removeAllObjects()
    }
    
    func ifSuccessResult(_ CLASSN: String,  responseObject:  Any? , haveResult :((_ responseDict:  [String:Any]) -> Void)?, haveNoResult :((_ message: String) -> Void)?){
        
        // ERRORS
        
        if let error_line = self.errorsEdit(responseObject, nameFunc: CLASSN) {
            
            haveNoResult?(error_line)
            
            return
        }
        
        // RESULT
        let responseDict = responseObject as! [String:Any]
        
        
        haveResult?(responseDict)
        
        
    }
    
    func ifFailResult(_ CLASSN: String, error : Error, haveNoResult :((_ message: String) -> Void)?){
        
        var logLine = "\nfailure in " +  CLASSN
        logLine += "\nerror.localizedDescription - " + error.localizedDescription
        logLine += "\ncode -  \((error as NSError).code)"
        
        print(logLine)
        
        if (error as NSError).code == -999 {
            return
        }
        
        if (error as NSError).code == -401{ // 401
            refreshToken(haveNoResult)
            return
        }
        
        haveNoResult?(error.localizedDescription)
        
    }
    
    func refreshToken(_ haveNoResult :((_ message: String) -> Void)?){

        
    }
    
    
    
    func errorsEdit(_ responseObject: Any?, nameFunc: String, shouldPrint: Bool = true) -> String? {
        
        
        if responseObject == nil {
            
            let error_string =  "responseObject is NILL"
            
            print("parse in " + nameFunc + "with error" + error_string)
            
            return error_string
            
        }
        
        
        
        if !(responseObject! is NSDictionary) {
            
            let error_string =  "responseObject is not kind of NSDictionary"
            
            print("parse in " + nameFunc + "with error" + error_string)
            
            return error_string
            
        }
        
        
        let responseDict = responseObject as! [String:Any]
        
        if shouldPrint {
            
            //            print(responseObject)
            
            print("\n\n responseDict in ",nameFunc ,"\n ",responseDict," \n\n")
            
        } else {
            print("\n\n OK from  ", nameFunc ,"\n")
        }
        
        
        
        
        if  let status_str = responseDict["status"] as? String {
            
            if status_str == "fail" {
                
                if let data_dict = responseDict["data"] as? NSDictionary {
                    
                    if let message_str = data_dict.object(forKey: "message") as? String {
                        
                        print("fail in " + nameFunc + ", with error = " + message_str)
                        
                        return message_str + " "
                    }
                    
                    if  let code = data_dict["code"] as? Int {
                        
                        if [400,403,404].contains(code) {
                            return nil
                        }
                    }
                }
                
                
                return "status = fail"
                
            }
            
            
            if status_str == "error" {
                
                if let message_str = responseDict["message"] as? String {
                    
                    print("error in " + nameFunc + "with error" + message_str)
                    
                    return message_str + " "
                }
                
                return "status = error"
                
            }
            
            if status_str == "success" {
                
                return nil
                
            }
            
            
        }
        
        
        
        return nil
        
    }
    
    
    func doNetStuff(PATH : String,
                    TYPE: String,
                    VARS : [String : Any]?,
                    ERROR haveNoResult :((_ message: String) -> Void)?,
                    FILL haveResult :((_ responseDict:  [String: Any]) -> Void)?,
                    UPLOADST uploadsD: ((AFMultipartFormData) -> Void)? = nil){
        
        if updateRequest {
            activeWindwowWillBeClosed()
        }
        
        let _manager = setHeaders(updateRequest ? session_manager : AFHTTPSessionManager())
       
        updateRequest = false
        
        let PARAMS = VARS == nil ? NSDictionary() : NSDictionary(dictionary: VARS!)
        let CLASSN = "doNetStuff"
        let web_path = kServerApi + PATH
        

        var task : URLSessionDataTask? = nil
        
        switch TYPE {
        case kPOST:
            
            task = _manager.post( web_path, parameters: PARAMS, progress: nil,
                                  success: { (operation: URLSessionDataTask, responseObject:  Any? ) -> Void in
                                    
                                    self.ifSuccessResult(CLASSN, responseObject: responseObject, haveResult: haveResult, haveNoResult: haveNoResult)
            },
                                  
                                  failure: { (operation : URLSessionDataTask? , error: Error ) -> Void in
                                    
                                    self.ifFailResult(CLASSN, error: error, haveNoResult: haveNoResult)
            })
            
            
        case kGET:
            
            task = _manager.get( web_path, parameters: PARAMS, progress: nil,
                                 
                                 success: { (operation: URLSessionDataTask, responseObject:  Any? ) -> Void in
                                    self.ifSuccessResult(CLASSN, responseObject: responseObject, haveResult: haveResult, haveNoResult: haveNoResult)
            },
                                 
                                 failure: { (operation : URLSessionDataTask? , error: Error ) -> Void in
                                    self.ifFailResult(CLASSN, error: error, haveNoResult: haveNoResult)
                                    
            })
            
        case kPATCH:
            
            
            task = _manager.patch( web_path, parameters: PARAMS, progress: nil,
                                 
                                 success: { (operation: URLSessionDataTask, responseObject:  Any? ) -> Void in
                                    self.ifSuccessResult(CLASSN, responseObject: responseObject, haveResult: haveResult, haveNoResult: haveNoResult)
            },
                                 
                                 failure: { (operation : URLSessionDataTask? , error: Error ) -> Void in
                                    self.ifFailResult(CLASSN, error: error, haveNoResult: haveNoResult)
                                    
            })
            
            
            
        case kDELETE:
            task = _manager.delete( web_path, parameters: PARAMS, progress: nil,
                                   
                                   success: { (operation: URLSessionDataTask, responseObject:  Any? ) -> Void in
                                    self.ifSuccessResult(CLASSN, responseObject: responseObject, haveResult: haveResult, haveNoResult: haveNoResult)
            },
                                   
                                   failure: { (operation : URLSessionDataTask? , error: Error ) -> Void in
                                    self.ifFailResult(CLASSN, error: error, haveNoResult: haveNoResult)
                                    
            })
            
        case kUPLOAD:
            
            task = _manager.post( web_path,  parameters: PARAMS,
                                  
                                  constructingBodyWith : uploadsD, progress: nil,
                                  
                                  success: { (operation: URLSessionDataTask, responseObject:  Any? ) -> Void in
                                    self.ifSuccessResult(CLASSN, responseObject: responseObject, haveResult: haveResult, haveNoResult: haveNoResult)
            },
                                  failure: { (operation : URLSessionDataTask? , error: Error ) -> Void in
                                    
                                    self.ifFailResult(CLASSN, error: error, haveNoResult: haveNoResult)
            })
            
        default:
            
            break
        }
        
        
        if (task != nil) && (newManager){
            array_of_tasks.add(task!)
        }
        
    }
    
    
    
}
