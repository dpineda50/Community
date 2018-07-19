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
    
    var albumsContents = [DocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        downloadAlbumCovers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    private func setupTableView() {
        let albumCellNib = UINib(nibName: "AlbumCell", bundle: Bundle.main)
        tableView.register(albumCellNib, forCellReuseIdentifier: "AlbumCell")
    }
    
    private func downloadAlbumCovers() {
        Firestore.firestore().collection("/albums").getDocuments { [weak self] (snap, error) in
            guard let strongSelf = self else { return }
            guard let snap = snap else { print(error?.localizedDescription ?? "An error occurred."); return }
            strongSelf.albumsContents = snap.documents
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
            }
        }
    }

    //MARK: - TableView DataSource/Delegate Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsContents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        cell.configure(indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? AlbumCell {
            let data = albumsContents[indexPath.row].data()
            cell.configure(with: data)
        }
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
                let album = albumsContents[indexPath.row]
                destinationVC.album = album
            }
        }
    }
}

