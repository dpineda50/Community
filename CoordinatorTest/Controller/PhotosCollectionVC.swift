 //
//  PhotosCollectionVC.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/13/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "PhotoCell"

class PhotosCollectionVC: UICollectionViewController{
    
    let store = PhotoStore()
    
    lazy var photoCellSize: CGSize = {
        return CGSize(width: view.bounds.width, height: view.bounds.height * 0.2)
    }()
    
    var album: DocumentSnapshot!
    
    var albumPath: String {
        return "albums/\(album.documentID)"
    }
    
    var albumTitle: String {
        return album.data()?["name"] as! String
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView?.reloadData()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.store.getImages(at: self?.albumPath ?? "") {
                DispatchQueue.main.async {
                    guard let collectionView = self?.collectionView else { return }
                    guard self?.view.bounds.contains(collectionView.frame) == true else { return }
                    collectionView.reloadSections(IndexSet(integer: 0))
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .purple

        // Register cell classes
        let photoCellNib = UINib(nibName: "PhotoCell", bundle: Bundle.main)
        self.collectionView!.register(photoCellNib, forCellWithReuseIdentifier: reuseIdentifier)
 
        title = albumTitle
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return store.photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        // load photo model from DataStore
        let photo = store.photos[indexPath.row]
        
        // let view determine how to setup content
        cell.displayContent(name: photo.url.absoluteString, image: photo.image)
        
        return cell
    }
}

extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoCellSize
    }
}
