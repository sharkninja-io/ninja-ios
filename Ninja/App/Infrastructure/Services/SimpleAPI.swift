//
//  SimpleAPI.swift
//  SharkRobot
//
//  Created by Tyler Hall on 4/20/20.
//  Copyright © 2020 SharkNinja. All rights reserved.
//

import Foundation

class SimpleAPI {

    var baseURL: URL

    var extraAdditionalHTTPHeaders = [String: String?]()
    var additionalHTTPHeaders: [String: String?] {
        return extraAdditionalHTTPHeaders
    }

    init(baseURL: URL) {
        self.baseURL = baseURL
    }

    private var task: URLSessionDataTask?
    
    func get(path: String?, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        var fullURL: URL
        if let path = path {
            fullURL = baseURL.appendingPathComponent(path)
        } else {
            fullURL = baseURL
        }

        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"

        Logger.Debug(request.curlString)

        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion?(false, nil, response as? HTTPURLResponse, error)
                return
            }

            completion?(true, data, response as? HTTPURLResponse, error)
        }

        task?.resume()
    }
    
    func getJSON(path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        let fullURL = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: fullURL)
        request.httpMethod = "GET"

        request.addValue("application/json", forHTTPHeaderField: "Accept")
        for (header, value) in additionalHTTPHeaders {
            if let value = value {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }
        
        Logger.Debug(request.curlString)

        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion?(false, nil, response as? HTTPURLResponse, error)
                return
            }

            completion?(true, data, response as? HTTPURLResponse, error)
        }

        task?.resume()
    }

    func postJSON(_ json: [String: Any?], withPath path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        sendJSON(json, withMethod: "POST", path: path) { (success, data, response, error) in
            completion?(success, data, response, error)
        }
    }

    func putJSON(_ json: [String: Any?], withPath path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        sendJSON(json, withMethod: "PUT", path: path) { (success, data, response, error) in
            completion?(success, data, response, error)
        }
    }

    func putData(_ data: Data, withPath path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        sendData(data, withMethod: "PUT", path: path) { (success, data, response, error) in
            completion?(success, data, response, error)
        }
    }

    private func sendData(_ data: Data, withMethod method: String, path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        let body = data
        let fullURL = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: fullURL)
        request.httpMethod = method.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        request.httpBody = body

        for (header, value) in additionalHTTPHeaders {
            if let value = value {
                request.addValue(value, forHTTPHeaderField: header)
            }
        }

        task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion?(false, nil, response as? HTTPURLResponse, error)
                return
            }

            completion?(true, data, response as? HTTPURLResponse, error)
        }

        task?.resume()
    }
    
    private func sendJSON(_ json: [String: Any?], withMethod method: String, path: String, completion: ((Bool, Data?, HTTPURLResponse?, Error?) -> Void)? = nil) {
        do {
            let body = try JSONSerialization.data(withJSONObject: json)
            let fullURL = baseURL.appendingPathComponent(path)

            var request = URLRequest(url: fullURL)
            request.httpMethod = method.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
            request.httpBody = body

            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            for (header, value) in additionalHTTPHeaders {
                if let value = value {
                    request.addValue(value, forHTTPHeaderField: header)
                }
            }
            
            Logger.Debug(request.curlString)

            task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    completion?(false, nil, response as? HTTPURLResponse, error)
                    return
                }

                completion?(true, data, response as? HTTPURLResponse, error)
            }

            task?.resume()
        } catch {
            completion?(false, nil, nil, nil)
        }
    }
}
