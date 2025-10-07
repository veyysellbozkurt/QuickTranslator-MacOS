//
//  SwiftyTranslate.swift
//  SwiftyTranslate
//
//  Created by Christoph Pageler on 15.12.20.
//  Refactored by Veysel Bozkurt on 07.10.2025.
//

import Foundation

public enum SwiftyTranslateError: Error {
    case invalidURL
    case noData
    case tooManyRequests
    case invalidResponse
    case invalidFormat
}

public struct SwiftyTranslate {
    
    public struct Translation {
        public let origin: String
        public let translated: String
    }
        
    public static func translate(
        text: String,
        from source: String,
        to target: String,
        completion: @escaping (Result<Translation, SwiftyTranslateError>) -> Void
    ) {
        guard let url = makeURL(text: text, from: source, to: target) else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, _ in
            guard let httpResponse = response as? HTTPURLResponse else {
                return completion(.failure(.invalidResponse))
            }
            
            guard httpResponse.statusCode != 429 else {
                return completion(.failure(.tooManyRequests))
            }
            
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            guard let translation = parse(data: data) else {
                return completion(.failure(.invalidFormat))
            }
            
            completion(.success(translation))
        }
        .resume()
    }
    
    // MARK: - Async/Await Wrapper
    public static func translate(
        text: String,
        from source: String,
        to target: String
    ) async throws -> Translation {
        try await withCheckedThrowingContinuation { continuation in
            translate(text: text, from: source, to: target) { result in
                continuation.resume(with: result)
            }
        }
    }
}

// MARK: - Private Helpers
private extension SwiftyTranslate {
    
    static func makeURL(text: String, from source: String, to target: String) -> URL? {
        var components = URLComponents(string: "https://translate.googleapis.com/translate_a/single")
        components?.queryItems = [
            .init(name: "client", value: "gtx"),
            .init(name: "sl", value: source),
            .init(name: "tl", value: target),
            .init(name: "dt", value: "t"),
            .init(name: "q", value: text)
        ]
        return components?.url
    }
    
    static func parse(data: Data) -> Translation? {
        guard
            let json = try? JSONSerialization.jsonObject(with: data) as? [Any],
            let firstLevel = json.first as? [Any],
            let sentences = firstLevel as? [[Any]]
        else {
            return nil
        }

        let translatedParts = sentences.compactMap { $0.first as? String }
        let originParts = sentences.compactMap { $0.dropFirst().first as? String }

        guard !originParts.isEmpty, !translatedParts.isEmpty else { return nil }

        let origin = originParts.joined()
        let translated = translatedParts.joined()
        return Translation(origin: origin, translated: translated)
    }
}
