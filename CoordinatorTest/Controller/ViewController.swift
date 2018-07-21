//
//  ViewController.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/13/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "AlbumCell"

class ViewController: UITableViewController {
    
    let store = AlbumStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        store.getAlbumImages {
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .right)
            }
        }
    }
    
    private func setupTableView() {
        let albumCellNib = UINib(nibName: "AlbumCell", bundle: Bundle.main)
        tableView.register(albumCellNib, forCellReuseIdentifier: "AlbumCell")
    }
    
    //MARK: - TableView DataSource/Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.albums.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = store.albums[indexPath.row]
        cell.displayContents(title: album.title, image: album.image)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToPhotosSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPhotosSegue" {
            if let destinationVC = segue.destination as? PhotosCollectionVC,
                let indexPath = tableView.indexPathForSelectedRow {
                
                let album = store.albumsContents[indexPath.row]
                destinationVC.album = album
            }
        }
    }
}

