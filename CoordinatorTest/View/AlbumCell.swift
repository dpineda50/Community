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
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func displayContents(title: String, image: UIImage) {
        albumLabel.text = title
        albumImageView.image = image
    }
}
