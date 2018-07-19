//
//  AlbumCell.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/13/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func configure(indexPath: IndexPath) {
        
        albumLabel?.text = "\(indexPath.row + 1)"
        
        if albumImageView.image == nil {
            albumImageView?.backgroundColor = .blue
        }
    }
    
    func configure(with data: Dictionary<String, Any>?) {
        if let albumTitle = data?["name"] as? String {
            albumLabel.text = albumTitle
        }
    }
}
