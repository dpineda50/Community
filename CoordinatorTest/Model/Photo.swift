//
//  PhotoCell.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/15/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import Firebase
import UIKit

class Photo {
    let url: URL!
    var image: UIImage!
    
    init(url: URL, image: UIImage? = nil) {
        self.url = url
        self.image = image
    }
    
    func downloadImage(_ completion: ((UIImage) -> Void)? = nil) {
        guard let url = self.url else { return }
        guard url.absoluteString.hasPrefix("https://") else { self.image = UIImage(named: "defaultPic") ; return }
        
        if image == nil {
            let megabyte: Int64 = 1024 * 1024
            Storage.storage().reference(forURL: url.absoluteString).getData(maxSize: Int64(2 * megabyte)) {
                [weak self]
                (data, error) in
                
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                    return
                }
                guard let strongSelf = self else { return }
                guard let imageData = data else { return }
                
                if let image = UIImage(data: imageData) {
                    strongSelf.image = image
                    completion?(image)
                }
            }
        }
    }
}
