//
//  FaviconManager.swift
//  Architecture
//
//  Created by 서상의 on 2021/09/19.
//

import UIKit

class UIImageLoader {
    static let loader: UIImageLoader = .init()
    
    private let imageLoader: ImageLoader = .init()
    private var uuidMap: [UIImageView: UUID] = .init()
    
    private init() { }
    
    func load(_ url: URL, for imageView: UIImageView) {
        let token = imageLoader.load(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            
            do {
                let image = try result.get()
                
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } catch { }
        }
        
        if let token = token { uuidMap[imageView] = token }
    }
    
    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancel(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }
}

class ImageLoader {
    private let session: URLSession = .shared
    
    private var imageList: [URL: UIImage] = .init() {
        didSet {
            print()
            self.imageList.forEach({ print($0.key, "|", $0.value)})
            print()
        }
    }
    private var imageDownloadList: [UUID: URLSessionDataTask] = .init()
    
    func load(_ url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = self.imageList[url] {
            completion(.success(image))
            
            return nil
        }
        
        let uuid = UUID()
        let task = session.dataTask(with: url) { data, response, error in
            defer { self.removeImgaeDownload(with: uuid) }
            
            if let image = self.imageFromData(data) {
                print(">> \(url), \(image)")
                self.imageList[url] = image
                completion(.success(image))
                return
            }
            
            guard let error = error else { return }
            guard (error as NSError).code == NSURLErrorCancelled else { completion(.failure(error)); return }
        }
        
        task.resume()
        
        self.imageDownloadList[uuid] = task
        
        return uuid
    }
    
    func cancel(_ uuid: UUID) {
        self.imageDownloadList[uuid]?.cancel()
        self.removeImgaeDownload(with: uuid)
    }
}

private extension ImageLoader {
    func removeImgaeDownload(with uuid: UUID) {
        self.imageDownloadList.removeValue(forKey: uuid)
    }
    
    func imageFromData(_ data: Data?) -> UIImage? {
        guard let data = data else {
            return .init(systemName: "link.circle.fill")
        }
        return .init(data: data)
    }
}

extension UIImageView {
    func loadImage(at url: URL) {
        UIImageLoader.loader.load(url, for: self)
    }
    
    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }
}
