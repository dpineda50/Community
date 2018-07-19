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
    
}

class PhotosCollectionVC: UICollectionViewController{
    
    let store = DataStore.shared
    
    lazy var photoCellSize: CGSize = {
        return CGSize(width: view.bounds.width, height: view.bounds.height * 0.2)
    }()
    
    var album: DocumentSnapshot!
    
    var albumPath: String {
        return "albums/\(album.documentID)"
    }

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
        
        store.getImages(at: albumPath) {
            DispatchQueue.main.async {
                self.collectionView?.reloadSections(IndexSet(integer: 0))
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
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("willDisplayCell:\(indexPath)")
    }
    

    // MARK: UICollectionViewDelegate

    // Uncomment this method to specify if the specified item should be highlighted during tracking
    /*
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

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
