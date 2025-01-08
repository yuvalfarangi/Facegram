//
//  post.swift
//  FaceGram IOS
//
//  Created by Yuval Farangi on 07/12/2024.

import Foundation

class ServerAPI {
    
    static let shared = ServerAPI()
    let baseURL = "http://localhost:3000"
    
    func fetchData<T: Decodable>(endpoint: String, responseType: T.Type) async -> T? {
        let fullURL = "\(baseURL)\(endpoint)"
        guard let url = URL(string: fullURL) else {
            print("Invalid URL: \(fullURL)")
            return nil
        }
        
        do {
            // Fetch data from the server
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Decode the data into the expected type
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            print("Error fetching data from \(endpoint): \(error)")
            return nil
        }
    }

    
    
    func postData<T: Encodable, U: Decodable>(endpoint: String, requestData: T, responseType: U.Type) async -> U? {
        let fullURL = "\(baseURL)\(endpoint)"
        guard let url = URL(string: fullURL) else {
            print("Invalid URL: \(fullURL)")
            return nil
        }
        
        do {
            // Convert request data to JSON
            let jsonData = try JSONEncoder().encode(requestData)
            
            // Prepare the request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Send the request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for a successful response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server responded with status code \(httpResponse.statusCode)")
                return nil
            }
            
            // Decode the response into the expected type
            let decodedResponse = try JSONDecoder().decode(U.self, from: data)
            return decodedResponse
        } catch {
            print("Error posting data to \(endpoint): \(error)")
            return nil
        }
    }
    
    func deleteData<T: Decodable>(endpoint: String, responseType: T.Type) async -> T? {
        let fullURL = "\(baseURL)\(endpoint)"
        guard let url = URL(string: fullURL) else {
            print("Invalid URL: \(fullURL)")
            return nil
        }
        
        do {
            // Prepare the DELETE request
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            // Send the DELETE request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for a successful response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server responded with status code \(httpResponse.statusCode)")
                return nil
            }
            
            // Decode the response into the expected type
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            print("Error deleting data from \(endpoint): \(error)")
            return nil
        }
    }
    
    
    func patchData<T: Encodable, U: Decodable>(endpoint: String, requestData: T, responseType: U.Type) async -> U? {
        let fullURL = "\(baseURL)\(endpoint)"
        guard let url = URL(string: fullURL) else {
            print("Invalid URL: \(fullURL)")
            return nil
        }
        
        do {
            // Convert request data to JSON
            let jsonData = try JSONEncoder().encode(requestData)
            
            // Prepare the PATCH request
            var request = URLRequest(url: url)
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            // Send the PATCH request
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check for a successful response
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("Server responded with status code \(httpResponse.statusCode)")
                return nil
            }
            
            // Decode the response into the expected type
            let decodedResponse = try JSONDecoder().decode(U.self, from: data)
            return decodedResponse
        } catch {
            print("Error patching data to \(endpoint): \(error)")
            return nil
        }
    }

}

struct serverResponse : Codable{
    let message: String
    let status: Int?
}
