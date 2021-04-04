//
//  BusinessRequests.swift
//  quelp-app
//
//  Created by Marvin Labrador on 4/1/21.
//

import Foundation
import Moya
import SwiftyJSON

var businessRequestProvider = MoyaProvider<BusinessRequests>(plugins: [QAActivityIndicator(), QAResponseLogger(), QAResultParser()])

enum BusinessRequests {
    case getBusinesses(location: String, term: String)
    case getBusinessDetails(id: String)
}

extension BusinessRequests: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Api.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getBusinesses:
            return Constants.Api.getBusinesses
        case .getBusinessDetails(id: let id):
            return "\(Constants.Api.getBusinessDetails)/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBusinesses, .getBusinessDetails:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getBusinesses, .getBusinessDetails:
            return getStubData(fileName: "Generic_Success")
        }
    }
    
    var task: Task {
        switch self {
        case .getBusinesses(location: let location, term: let term):
            let parameters = ["location": location, "term": term]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getBusinessDetails:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let yelpAccessToken = "xhnjL5S1BiKcQlfXRL-gQHIe3MbMpLJjrCVpz6CPlPJDNQJ3Dh-Ns9SB_wVWVE3p8oXPj4vHDehCUjW5tBOkFrbd6NM4c1le0fOrI5PdjCiGI10l6n3refWLs5ZlYHYx"
        return ["Authorization": "Bearer \(yelpAccessToken)"]
    }
}
