//
//  WebAPI.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 10/02/25.
//

import Foundation

extension WebAPI {
    enum HttpMethod: String {
        case get
        case post
        case put
        case patch
        case delete
    }
}

//MARK: - Prepare URL REQUEST
class WebAPI {
    
    var requestHttpHeaders: [String:String] = [:]

    public func prepareRequest(withURL url: String, params: [String:Any], httpMethod: HttpMethod, specialPUTParams: String? = nil, specialGETParams: String? = nil) -> URLRequest? {
        
        guard let url = URL(string: url) else { return nil }
        var urlRequest = URLRequest(url: url) // initialize with url
        urlRequest.httpMethod = httpMethod.rawValue // set http method
        
        /*set http body*/
        switch httpMethod {
        case .post, .put, .delete:
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            
            if let params = specialPUTParams {
                let newParams = "\(params)"
                let urlString = urlRequest.url!.absoluteString + newParams
                urlRequest.url = URL(string: urlString)
            } else if let getParams = specialGETParams {
                let urlString = urlRequest.url!.absoluteString + getParams
                urlRequest.url = URL(string: urlString)
            }
        case .get:
            var queryParameters = "?"
            let sortedKeys = params.keys.sorted(by: { $0 < $1 })
            
            for k in sortedKeys {
                if let v = params[k] {
                    var stringValue = v as? String
                    stringValue = stringValue?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?.replacingOccurrences(of: ":", with: "%3A")
                    queryParameters += k + "=\(stringValue ?? v)"
                    queryParameters += "&"
                }
            }
            
            queryParameters.removeLast()
            
            var urlString = urlRequest.url!.absoluteString + queryParameters
            if let specialGETParams =  specialGETParams {
                urlString += params.isEmpty ? "?" : "&"
                urlString += specialGETParams
            }
            urlRequest.url = URL(string: urlString)
        default:
            break
        }
        
        /*set authorization header*/
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        for (header, value) in requestHttpHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: header)
        }

        return urlRequest
    }
}
