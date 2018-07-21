//
//  PhotoStore.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/21/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import Foundation
import Firebase

final class PhotoStore {
    
    var photos = [Photo]()
    // Getting Photos
    
    func getPhotos(at path: String, _ completion: @escaping () -> Void) {
        guard !path.isEmpty else { return }
        Firestore.firestore().document(path).getDocument { [weak self]
            (snap, error) in
            if let error = error {
                print("Error downloading images \(error.localizedDescription)")
            }
            guard let snap = snap else { print("This document does not exist"); return }
            guard let strongSelf = self else { return }
            if let data = snap.data(), let urls = data["photos"] as? [String] {
                let actualURLS = urls.compactMap { URL(string: $0) }
                strongSelf.photos = actualURLS.map{ Photo(url: $0) }
                completion()
            }
        }
    }
    
    func getImages(at path: String, _ completion: @escaping () -> Void) {
        getPhotos(at: path) {
            DispatchQueue.global().async {
                for photo in self.photos {
                    let url = URL(string: photo.url.absoluteString)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        photo.image = image
                    }
                }
                completion()
            }
        }
    }
    
    init() {
        print("Initializing \(self)")
    }
    
    deinit {
        print("Deinitializing photoStore \(self)")
    }
}
