//
//  ViewController.swift
//  SeSAC_SwiftConcurrency
//
//  Created by 홍수만 on 2023/12/19.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //async await
//        Task { // viewdidLoad는 동기 코드이기 때문에 내부에서 비동기를 사용할 수 있게 Task를 사용한다
//            let image1 = try await Network.shared.fetchThumbnailAsyncAwait(value: "jpD6z9fgNe7OqsHoDeAWQWoULde")
//            posterImageView.image = image1
//            let image2 = try await Network.shared.fetchThumbnailAsyncAwait(value: "bf5B7yMx62jYvJfZCF62rhdXcQ3")
//            secondImageView.image = image2
//            let image3 = try await Network.shared.fetchThumbnailAsyncAwait(value: "6jByCqeQXEu3RR5qvlTCBamJQED")
//            
//            thirdImageView.image = image3
//        }
        //async let
//        Task {
//            let result = try await Network.shared.fetchThumbnailAsyncLet()
//            
//            posterImageView.image = result[0]
//            secondImageView.image = result[1]
//            thirdImageView.image = result[2]
//        }
        //taskgroup
        Task {
           let value = try await Network.shared.fetchThumbnailTaskGroup()
            
            posterImageView.image = value[0]
            secondImageView.image = value[1]
            thirdImageView.image = value[2]
        }
        
//        Network.shared.fetchThumbnail { image in
//            print(1)
//        }
//        Network.shared.fetchThumbnail { image in
//            print(2)
//        }
//        Network.shared.fetchThumbnail { image in
//            print(3)
//        }
        
//        Network.shared.fetchThumbnail { image in
//            self.posterImageView.image = image
//        }
        
//        Network.shared.fetchThumbnailURLSession { data in
//            switch data {
//            case .success(let value):
//                DispatchQueue.main.async {
//                    self.posterImageView.image = value
//                }
//
//            case .failure(let failure):
//                DispatchQueue.main.async {
//                    self.posterImageView.backgroundColor = .gray
//                }
//                print(failure)
//            }
//        }
        
    }


}

