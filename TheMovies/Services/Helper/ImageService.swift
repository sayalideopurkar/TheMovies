//
//  ImageService.swift
//  TheMovies
//
//  Created by Sayali Deopurkar on 21/04/22.
//

import Foundation
/**
 ImageService with caching using NSCache
 */
protocol ImageService {
    func load(url: URL) async throws -> Data
}

final class ImageServiceImpl: ImageService {

    private let cachedImages = NSCache<NSURL, NSData>()
    /// Returns the cached image if available, otherwise asynchronously loads and caches it.
    func load(url: URL) async throws -> Data {
        if let cachedImageData = cachedImages.object(forKey: url as NSURL) {
            return cachedImageData as Data
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.cachedImages.setObject(data as NSData, forKey: url as NSURL, cost: data.count)
            return data
            
        } catch {
            throw HTTPError.invalidRequest
        }
    }
}
