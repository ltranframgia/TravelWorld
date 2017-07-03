//
//  TimelineRouter.swift
//  TravelWorld
//
//  Created by Henry Tran on 7/5/17.
//  Copyright © 2017 THL. All rights reserved.
//

import Alamofire

enum TimelineRouter: URLRequestConvertible {
    case getList

    var method: HTTPMethod {
        switch self {
        case .getList:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getList :
            return "/api/timeline"
        }
    }
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Config.baseUrl.asURL()

        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue

        switch self {
        case .getList:
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: nil)
        }

        return urlRequest
    }
}
