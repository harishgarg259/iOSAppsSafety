//
//  RestManager.swift
//  iOSAppsSafety
//
//  Created by Harish Garg on 10/02/25.
//

import Foundation

enum Result<T: Codable> {
    case success(T)
    case failure(WebError)
}

class RestManager<T: Codable> {
    
    // MARK: - Properties
    var requestHttpHeaders: [String:String] = [:]
    var response: [String:Any] = [:]
    
    // MARK: - Public Methods
    func makeRequest(request : URLRequest, completion: @escaping (_ result: Result<T>) -> Void) {
        
        //Return if mobile is not connected with the internet
        if !isConnectedToNetwork() {
            completion(.failure(.networkLost))
            return
        }
        
        
        // Create a background queue
        DispatchQueue.global(qos: .background).async {
            /*HTTP REQUEST*/
            
            //SSL pinning to secure API connection
            let session = URLSession(configuration: .default, delegate: URLSessionPinningDelegate(), delegateQueue: nil)
            
            
            let task = session.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let response = response as? HTTPURLResponse else {
                        if (error?.localizedDescription) != nil {
                            completion(.failure(.other(error?.localizedDescription ?? "")))
                            return
                        }
                        completion(.failure(.networkLost))
                        return
                    }
                    
                    /*RESPONSE*/
                    /***********************************************/
                    
                    switch response.statusCode {
                    case (200..<300):
                        guard let model = Response<T>().parceModel(data: data) else {
                            completion(.failure(WebError.parse))
                            return
                        }
                        completion(.success(model))
                    case (300...600):
                        guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                            completion(.failure(.other((error?.localizedDescription) ?? "Internal server error")))
                            return
                        }
                        let message = json["query_status"] as? String ?? WebError.unauthorized.description
                        completion(.failure(.other(message)))
                    default:
                        break
                    }
                }
            }
            task.resume()
        }
    }
}

class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        guard let serverTrust = challenge.protectionSpace.serverTrust,
              let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            return
        }
        
        // Load local certificate
        if let path = Bundle.main.path(forResource: "urlhaus", ofType: "cer"),
           let localCertificateData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
            
            // 0 means we want only leaf certificate from list as you can see in above screensshost
            
            // Set SSL policies for domain name check
            let policies = NSMutableArray()
            policies.add(SecPolicyCreateSSL(true, (challenge.protectionSpace.host as CFString)))
            SecTrustSetPolicies(serverTrust, policies)
            
            // certificate Pinning
            
            let isServerTrust = SecTrustEvaluateWithError(serverTrust, nil)
            
            // local and server data
            // evalutate the certificate
            let remoteCertData: NSData = SecCertificateCopyData(serverCertificate)
            
            // compare both data
            if isServerTrust && remoteCertData.isEqual(to: localCertificateData as Data) {
                let credential = URLCredential(trust: serverTrust)
                print("certificate pinning is successful")
                completionHandler(.useCredential, credential
                )
            } else {
                completionHandler(.cancelAuthenticationChallenge, nil)
            }
        }
        
        // Certificate does not match
        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}


// MARK: - RestManager Parce Model
extension RestManager {
    
    fileprivate struct Response<T: Codable> {
        
        func parceModel(data: Data?) -> T? {
            guard let data = data else {
                return nil
            }
            let mappedData = try? JSONDecoder().decode(T.self, from: data)
            return mappedData
        }
    }
}
