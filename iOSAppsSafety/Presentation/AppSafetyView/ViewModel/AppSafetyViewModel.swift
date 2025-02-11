//
//  AppSafetyViewModel.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 2025-02-10.
//

import SwiftUI

class AppSafetyViewModel: ObservableObject {
    
    
    // MARK: - Properties
    @Published var appsList: [Urls] = []
    @Published var error: WebError?
    @Published var state: FetchState = .idle

    
    init() {
        //Intially call API
        self.state = .idle
        appsListCall()
    }
    
    // MARK: - API Functions
    /*
     API Call for apps listing
     */
    private func appsListCall() {
        let rest = RestManager<AppSafetyModel>()
        let parameters = ["limit":"\(AppConstants.limitPerPage)"]
        
        state = .isLoading

        rest.makeRequest(request : WebAPI().appsList(params : parameters, type: .appsList)!) { (result) in
            
            switch result {
                
            case .success(let response):
                
                debugPrint(response)
                
                if response.urls?.isEmpty ?? true{
                    self.state = .error("No Apps Found")
                } else {
                    self.appsList = response.urls ?? []
                    self.state = .loadedAllApps
                }
                
            case .failure(let error):
                debugPrint(error.description)
                self.error = error
                self.state = .error(error.description)
            }
            
        }
    }
}
