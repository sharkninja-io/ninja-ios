//
//  URL+Extensions.swift
//  SharkClean
//
//  Created by Tyler Hall on 5/17/22.
//

import Foundation

extension URL {
    static func createTempFileURL() -> URL {
        return FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
    }
    
    /// Returns a new URL by adding the query items, or nil if the URL doesn't support it.
    /// URL must conform to RFC 3986.
    func queryParameters(_ queries: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            // URL is not conforming to RFC 3986 (maybe it is only conforming to RFC 1808, RFC 1738, and RFC 2732)
            return nil
        }
        // append the query items to the existing ones
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queries

        // return the url from new url components
        return urlComponents.url
    }
}


extension URLRequest {
    
    enum HTTPMethod: String {
        case Get
        case Put
        case Post
        case Delete
    }
    
    /**
     Returns a cURL command representation of this URL request.
      source https://gist.github.com/shaps80/ba6a1e2d477af0383e8f19b87f53661d
     */
    public var curlString: String {
        guard let url = url else { return "" }
        var baseCommand = #"curl "\#(url.absoluteString)""#

        if httpMethod == "HEAD" {
            baseCommand += " --head"
        }

        var command = [baseCommand]

        if let method = httpMethod, method != "GET" && method != "HEAD" {
            command.append("-X \(method)")
        }

        if let headers = allHTTPHeaderFields {
            for (key, value) in headers where key != "Cookie" {
                command.append("-H '\(key): \(value)'")
            }
        }

        if let data = httpBody, let body = String(data: data, encoding: .utf8) {
            if allHTTPHeaderFields?["Content-Type"] == "application/json" {
                command.append("--data-raw '\(body)'")
            } else {
                command.append("-d '\(body)'")
            }
        }

        return command.joined(separator: " \\\n\t")
    }
}

extension Data {
    func jsonObject() -> [String: Any]? {
        do {
            let responseJSON = try JSONSerialization.jsonObject(with: self, options: [])
            return responseJSON as? [String: Any]
        } catch {
            return nil
        }
    }
}

extension HTTPURLResponse {
    func isValid(validStatusCodes: Range<Int> = 200..<300) -> Bool {
        return validStatusCodes.contains(self.statusCode)
    }
}

extension HTTPURLResponse {
    public var isInformationalResponse: Bool {
        return (100...199) ~= statusCode
    }
    
    public var isSuccesfulResponse: Bool {
        return (200...299) ~= statusCode
    }
    
    public var isRedirectionalResponse: Bool {
        return (300...399) ~= statusCode
    }
    
    public var isClientErrorResponse: Bool {
        return (400...499) ~= statusCode
    }
    
    public var isServerErrorResponse: Bool {
        return (500...599) ~= statusCode
    }
}
