//
//  DataStore.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/18/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import Foundation
import Firebase

final class AlbumStore {
    var albumsContents = [DocumentSnapshot]()
    var albums = [Album]()
    var currentAlbumSet = ""
    
    // Getting Albums
    
    func getAlbumImages(_ completion: @escaping () -> Void) {
        downloadAlbums {
            DispatchQueue.global().async {
                for album in self.albums {
                    let url = URL(string: album.coverImageURL ?? "")
                    let data = try? Data(contentsOf: url!)
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        album.image = image
                    } else {
                        // place holder image for album
                    }
                }
                completion()
            }
        }
    }
    
    func downloadAlbums(_ completion: @escaping () -> Void) {
        Firestore.firestore().collection("/albums").getDocuments { [weak self] (snap, error) in
            guard let strongSelf = self else { return }
            guard let snap = snap else { print(error?.localizedDescription ?? "An error occurred."); return }
            strongSelf.albumsContents = snap.documents
            strongSelf.albums = snap.documents.compactMap {
                let title = $0.data()["name"] as! String
                let path = "albums/\($0.documentID)"
                let coverPhotoURL = ($0.data()["photos"] as! [String]).first
                return Album(title: title, path: path,coverImageURL: coverPhotoURL)
            }
            completion()
        }
    }
}
