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
    case getBusinesses(coordinates: LocationCoordinates, term: String)
    case getBusinessesWithLocationSearch(location: String, term: String)
    case getBusinessDetails(id: String)
    case getReviews(id: String)
}

extension BusinessRequests: TargetType {
    var baseURL: URL {
        return URL(string: Constants.Api.baseURL)!
    }
    
    var path: String {
        switch self {
        case .getBusinesses, .getBusinessesWithLocationSearch:
            return Constants.Api.getBusinesses
        case .getBusinessDetails(id: let id):
            return "\(Constants.Api.getBusinessDetails)/\(id)"
        case .getReviews(id: let id):
            return "\(Constants.Api.getBusinessDetails)/\(id)/reviews"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getBusinesses, .getBusinessDetails, .getBusinessesWithLocationSearch, .getReviews:
            return .get
        }
    }
    
    var sampleData: Data {
        switch self {
        case .getBusinesses, .getBusinessDetails, .getBusinessesWithLocationSearch, .getReviews:
            return getStubData(fileName: "Generic_Success")
        }
    }
    
    var task: Task {
        switch self {
        case .getBusinesses(coordinates: let coordinates, term: let term):
            let parameters = ["longitude": "\(coordinates.longitude ?? -73.561668)", "latitude": "\(coordinates.latitude ?? 45.508888)", "term": term] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getBusinessesWithLocationSearch(location: let location, term: let term):
            var parameters = ["location": location]
            if term.trimmed != "" { parameters["term"] = term }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getBusinessDetails, .getReviews:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let yelpAccessToken = "xhnjL5S1BiKcQlfXRL-gQHIe3MbMpLJjrCVpz6CPlPJDNQJ3Dh-Ns9SB_wVWVE3p8oXPj4vHDehCUjW5tBOkFrbd6NM4c1le0fOrI5PdjCiGI10l6n3refWLs5ZlYHYx"
        return ["Authorization": "Bearer \(yelpAccessToken)"]
    }
}
