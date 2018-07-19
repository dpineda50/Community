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

extension PhotoCell {
    func configure(with cell: Photo) {
        self.label.text = cell.url.absoluteString
        if cell.image != nil {
            self.imageView.image = cell.image
        }
    }
}

class PhotosCollectionVC: UICollectionViewController{
    
    var photos = [Photo]() {
        didSet {
            collectionView?.reloadData()
            DispatchQueue.global().async {
                [weak self] in
                self?.downloadPhotos()
            }
        }
    }
    
    
    lazy var photoCellSize: CGSize = {
        return CGSize(width: view.bounds.width, height: view.bounds.height * 0.2)
    }()
    
    var album: DocumentSnapshot!

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .purple
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        let photoCellNib = UINib(nibName: "PhotoCell", bundle: Bundle.main)
        self.collectionView!.register(photoCellNib, forCellWithReuseIdentifier: reuseIdentifier)
        title = album.data()?["name"] as? String

        // Do any additional setup after loading the view.
        installsStandardGestureForInteractiveMovement = true
        
        loadImages()
    }
    
    private func downloadPhotos() {
        photos.forEach { (photo) in
            if photo.image == nil {
                photo.downloadImage()
            }
        }
    }
    
    private func loadImages() {
        let path = "albums/\(album.documentID)"
        Firestore.firestore().document(path).getDocument { [weak self]
            (snap, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Error downloading images \(error.localizedDescription)")
            }
            guard let snap = snap else { print("This document does not exist"); return }
            
            if let data = snap.data() {
                if let urls = data["photos"] as? [String] {
                    print("we in here")
                    let actualURLS = urls.compactMap { URL(string: $0) }
                    strongSelf.photos = actualURLS.map{ Photo(url: $0) }
                }
            } else {
                print("could not do it ")
            }
            
            DispatchQueue.main.async {
                strongSelf.collectionView?.reloadData()
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("collectionView.cellForItemAt: \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
    
        cell.imageView.image = nil
        
        // Configure the cell
        let photo = photos[indexPath.row]
        
        if photo.image == nil {
            DispatchQueue.global().async {
                photo.downloadImage { (image) in
                    DispatchQueue.main.async { [weak self] in
                        self?.collectionView?.reloadItems(at: [indexPath])
                    }
                }
            }
        } else {
            cell.imageView.image = photo.image
        }
        
        cell.configure(with: photo)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplayCell:\(indexPath)")
        
        if let cell = cell as? PhotoCell {
            let photo = photos[indexPath.row]
            if cell.imageView.image == nil {
                cell.configure(with: photo)
            }
        }
    }
    

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
 

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

extension PhotosCollectionVC: UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return photoCellSize
    }
}
