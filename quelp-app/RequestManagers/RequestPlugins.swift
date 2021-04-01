//
//  RequestPlugins.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation
import Moya
import SwiftyJSON
import Result


public final class QAActivityIndicator: PluginType {
    
    public func willSend(_ request: RequestType, target: TargetType) {
        showLoading()
    }
    
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        hideLoading()
    }
}

public final class QAResponseLogger: PluginType {
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if let requestURL = result.value?.request?.url {
            print("API REQUEST URL:\n\(requestURL)")
        }
        
        if let requestBody = result.value?.request?.httpBody {
            let jsonBody = JSON(requestBody)
            print("REQUEST PARAMETERS:\n\(jsonBody)")
        }
        
        if let headers = result.value?.request?.allHTTPHeaderFields {
            let jsonHeaders = JSON(headers)
            print("REQUEST HEADERS:\n\(jsonHeaders)")
        }
        
        print("RESPONSE:")
        switch result {
        case .success(let response):
            if JSON(response.data) == JSON.null {
                print("STATUS CODE: \(response.statusCode)")
                return
            }
            let responseJSON = JSON(response.data)
            print(responseJSON)
        case .failure(let error):
            if error.response != nil {
                if let errorResponse = error.response {
                    let errorJSON = JSON(errorResponse.data)
                    print(errorJSON)
                    return
                }
            }
            print(error)
        }
    }
}

public final class QAResultParser: PluginType {
    
    public func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
        
        switch result {
        case .success(let response):
            do {
                let successResponse = try response.filterSuccessfulStatusCodes() // 200-299 status codes only
                let jsonResponse: JSON? = JSON(successResponse.data)
                guard let isSuccessful = jsonResponse?["success"].bool, isSuccessful == true else {
                    guard (jsonResponse?["error_code"].string) != nil else {
                        return result // return with internet connection error
                    }
                    return handleCustomErrors(response: response)
                }
                return result // return success response
            } catch {
                let responseJson = JSON(response.data)
                if responseJson != JSON.null {
                    if responseJson["error_code"] == JSON.null && responseJson["code"] == JSON.null {
                        return handleNetworkErrors()
                    }
                } else if responseJson == JSON.null {
                    return handleNetworkErrors()
                }
                return handleCustomErrors(response: response)
            }
            
        case .failure(let error):
            if let nsError = (error as NSError?), nsError.localizedDescription == "cancelled" {
                return handleCancelErrors()
            }
            
            if error.response == nil {
                return handleNetworkErrors() // Internet connection errors
            } else {
                if let errorResponse = error.response {
                    let errorJSON = JSON(errorResponse.data)
                    if errorJSON["error_code"] == JSON.null {
                        return handleNetworkErrors()
                    }
                }
            }
            
            return result
        }
    }
    
    func handleRedirectCodes(result: Result<Response, MoyaError>) -> Result<Response, MoyaError> {
        let redirectJSON = JSON(result.value!.data)
        if let redirectLink = URL.init(string: redirectJSON["redirect_link"].stringValue) {
            UIApplication.shared.open(redirectLink, options: [:], completionHandler: nil)
        }
        return result
    }
    
    func handleCustomErrors(response: Response) -> Result<Response, MoyaError> {
        let customError = MoyaError.jsonMapping(response)
        let customResult = Result<Response, MoyaError>.init(nil, failWith: customError)
        return customResult //return custom error handler
    }
    
    func handleNetworkErrors() -> Result<Response, MoyaError> {
        let errorCode = ["error_code": "ERROR_NETWORK"]
        let errorData = try! JSONSerialization.data(withJSONObject: errorCode, options: .prettyPrinted)
        let errorResponse = Response(statusCode: 0, data: errorData)
        return Result<Response, MoyaError>.init(nil, failWith: MoyaError.jsonMapping(errorResponse))
    }
    
    func handleCancelErrors() -> Result<Response, MoyaError> {
        let errorCode = ["error_code": "CANCELLED"]
        let errorData = try! JSONSerialization.data(withJSONObject: errorCode, options: .prettyPrinted)
        let errorResponse = Response(statusCode: -999, data: errorData)
        return Result<Response, MoyaError>.init(nil, failWith: MoyaError.jsonMapping(errorResponse))
    }
}


extension TargetType {
    func getStubData(fileName: String) -> Data {
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        return try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
    }
}
