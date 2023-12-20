//
//  ViewController.swift
//  SeSAC_SwiftConcurrency
//
//  Created by 홍수만 on 2023/12/19.
//

/*
 @MainActor: Swift Concurrency 를 작성한 코드에서 다시 메인 쓰레드로 돌려주는 역할을 수행
 */

/*
 SwiftUI -> UIKit
 UIKit -> SwiftUI
 */

class MyClassA {
    var target: MyClassB?
    
    deinit {
        print("MyClassA Deinit")
    }
}

class MyClassB {
    var target: MyClassA?
    
    deinit {
        print("MyClassB Deinit")
    }
}

class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        
        view.backgroundColor = .gray
        
        let a = MyClassA()
        let b = MyClassB()
        
        a.target = b
        b.target = a
        
//        a.target = nil
    }
    
    deinit {
        print("DEINIT")
    }
}

import UIKit

class ViewController: UIViewController {

    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var secondImageView: UIImageView!
    @IBOutlet var thirdImageView: UIImageView!
    

    @IBAction func testButtonClicked(_ sender: UIButton) {
        
        let vc = HostingTestView(rootView: TestView())
        
        present(vc, animated: true)
        
//        present(DetailViewController(), animated: true)
    }
    
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
        Task {
            print(#function, "1", Thread.isMainThread, Thread.current)
            let result = try await Network.shared.fetchThumbnailAsyncLet()
            
            print(#function, "2", Thread.isMainThread, Thread.current)
            posterImageView.image = result[0]
            secondImageView.image = result[1]
            thirdImageView.image = result[2]
            print(#function, "3", Thread.isMainThread, Thread.current)
        }
        //taskgroup
//        Task {
//           let value = try await Network.shared.fetchThumbnailTaskGroup()
//            
//            posterImageView.image = value[0]
//            secondImageView.image = value[1]
//            thirdImageView.image = value[2]
//        }
        
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

