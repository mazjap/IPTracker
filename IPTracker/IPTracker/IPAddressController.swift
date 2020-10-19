//
//  IPAddressController.swift
//  IPTracker
//
//  Created by Jordan Christensen on 10/19/20.
//

import MapKit

class IPAddressController {
    enum NetworkError: Error {
        case encodingError
        case badResponse
        case noData
        case badDecode
        case noAuth
        case invalidInput
        case otherError(Error)
        case customError(String)
    }
    
    enum HTTPRequestType: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
    let baseURL = URL(string: "https://geo.ipify.org/api/v1")!
    
    func findLocationFromIP(ip: String, completion: @escaping (Result<IPResponseContainer, NetworkError>) -> Void) {
        var urlComponenets = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
        urlComponenets?.queryItems = [URLQueryItem(name: "apiKey", value: IPIFY_API_KEY), URLQueryItem(name: "ipAddress", value: ip)]
        
        guard let url = urlComponenets?.url else {
            completion(.failure(.invalidInput))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPRequestType.get.rawValue
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse,
               response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(.badResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            
            do {
                let ipResponse = try JSONDecoder().decode(IPResponseContainer.self, from: data)
                completion(.success(ipResponse))
            } catch {
                completion(.failure(.badDecode))
            }
        }.resume()
        
    }
}
