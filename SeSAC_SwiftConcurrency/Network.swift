//
//  Network.swift
//  SeSAC_SwiftConcurrency
//
//  Created by 홍수만 on 2023/12/19.
//

/*
 GCD vs Swift Concurrency
 - completino handler의 불편함
 - 비동기를 동기처럼
 
 - Thread Explosion
 - Context Switching
 -> 코어의 수와 쓰레드의 수를 같게
 -> 같은 쓰레드 내에서 Continuation 전환 형식으로 방식을 변경
 
 - async throws / try await : 비동기를 동기처럼
 - Task : 비동기 함수와 동기 함수를 연결
 - async let : dispatchGroup 처럼 동작
 - taskGroup :
 
 */

import UIKit

enum JackError: Error  {
    case invalidResponse
    case unknown
    case invalidImage
}

class Network {
    
    static let shared = Network()
    
    private init() { }
    
    func fetchThumbnail(completion: @escaping (UIImage) -> Void) {
        
        let url = "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/jpD6z9fgNe7OqsHoDeAWQWoULde.jpg"
        
        DispatchQueue.global().async {
            
            if let data = try? Data(contentsOf: URL(string: url)!) {
                
                if let image = UIImage(data: data) {
                    
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
    
    //URLSession
    func fetchThumbnailURLSession(completion: @escaping (Result<UIImage, JackError>) -> Void) {
        
        let url = URL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/jpD6z9fgNe7OqsHoDeAWQWoULde.jpg")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let data else {
                completion(.failure(.unknown))
                return
            }
            
            guard error == nil else {
                completion(.failure(.unknown))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let image = UIImage(data: data) else {
                completion(.failure(.invalidImage))
                return
            }
            
            completion(.success(image))
            
        }.resume()
    }
    
    //async 비동기로 작업할 함수에요~
//    @MainActor
    func fetchThumbnailAsyncAwait(value: String) async throws -> UIImage {
        
        //jpD6z9fgNe7OqsHoDeAWQWoULde
        //bf5B7yMx62jYvJfZCF62rhdXcQ3.jpg
        //6jByCqeQXEu3RR5qvlTCBamJQED.jpg
        
        print(#function, "1", Thread.isMainThread, Thread.current)

        let url = URL(string: "https://www.themoviedb.org/t/p/w600_and_h900_bestv2/\(value).jpg")!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 5)
        
        //await: 비동기를 동기처럼 작업 할꺼니까, 응답 올 때까지 여기서 딱 기다려
        //URLSession이 통신하고 data와 response에 값이 들어갈 때까지 기다린다
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print(#function, "2", Thread.isMainThread, Thread.current)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw JackError.invalidResponse
        }
        
        guard let image = UIImage(data: data) else {
            throw JackError.invalidImage
        }
        
        print(url.description)
        
        return image
    }
    
    @MainActor
    func fetchThumbnailAsyncLet() async throws -> [UIImage] { //fetchThumbnailAsyncAwait가 비동기 이기 때문에 async throws를 붙인다
        print(#function, "1", Thread.isMainThread, Thread.current)
        async let image1 = Network.shared.fetchThumbnailAsyncAwait(value: "jpD6z9fgNe7OqsHoDeAWQWoULde")
        async let image2 = Network.shared.fetchThumbnailAsyncAwait(value: "bf5B7yMx62jYvJfZCF62rhdXcQ3")
        async let image3 = Network.shared.fetchThumbnailAsyncAwait(value: "6jByCqeQXEu3RR5qvlTCBamJQED")
        
        print(#function, "2", Thread.isMainThread, Thread.current)
        
        return try await [image1, image2, image3] // try await -> 비동기 작업이 모두 배열에 담길 때까지 기다린다
    }
    
    func fetchThumbnailTaskGroup() async throws -> [UIImage] {
        let poster = ["jpD6z9fgNe7OqsHoDeAWQWoULde", "bf5B7yMx62jYvJfZCF62rhdXcQ3", "6jByCqeQXEu3RR5qvlTCBamJQED"]
        
        //
        return try await withThrowingTaskGroup(of: UIImage.self) { group in
            
            for item in poster {
                
                group.addTask { //몇 번의 비동기 작업을 진행할지 갯수를 세기 위해 addTask를 한다
                    try await self.fetchThumbnailAsyncAwait(value: item)
                }
            }
            
            var resultImages: [UIImage] = []
            
            for try await item in group {
                resultImages.append(item)
            }
            
            return resultImages
        }
    }
}

