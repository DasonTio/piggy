//
//  NetworkError.swift
//  piggy
//
//  Created by Dason Tiovino on 14/08/24.
//

import Foundation

enum NetworkError: Error{
    case invalidURL
    case invalidResponse
    case noData
    case invalidParameters
    case errorResponse(error: ResponseError)
    case genericError(error: Error)

    var errorMessage: String {
        switch self {
        case .errorResponse(let error):
            return error.message ?? "We couldn't connect to our data. Please retry again and make sure internet connection is good."
        default:
            return "We couldn't connect to our data. Please retry again and make sure internet connection is good."
        }
    }
}

struct ResponseError: Codable {
    public let code: String?
    public let message: String?
}

extension Error {
    func toResponseError() -> NetworkError {
        if let responseError = self as? NetworkError {
            return responseError
        } else {
            return .genericError(error: self)
        }
    }
}
