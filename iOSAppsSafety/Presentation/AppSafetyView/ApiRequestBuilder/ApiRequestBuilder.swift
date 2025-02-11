
//
//  ApiRequestBuilder.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//
import Foundation


//MARK: - Apps Screen Requests
extension WebAPI{
    
    enum APIRequest
    {
        //add new case for api if we are integrating new api on this view
        case appsList
        
        //added dummy case for api testing
        case failureRequest

    }
    
    func appsList(params: [String:Any] = [:], type : APIRequest, specialPUTParams: String? = nil, specialGETParams: String? = nil) -> URLRequest? {
        
        var requestURL : String?
        var httpMethod : HttpMethod = .get
        
        switch type {
            
            // For every api we can update request params
        case .appsList:
            httpMethod = .get
            requestURL = RequestUrl.appsListing.url
        case .failureRequest:
            httpMethod = .post
            requestURL = RequestUrl.appsListing.url
        }
        
        guard let request = WebAPI().prepareRequest(withURL: requestURL!, params: params, httpMethod: httpMethod, specialPUTParams: specialPUTParams, specialGETParams: specialGETParams) else {
            return nil
        }

        return request
    }
}
