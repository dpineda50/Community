//
//  PhotoCell.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/13/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(text: String) {
        
        guard label != nil else { return }
        label.text = text
        
        guard imageView != nil else { return }
        if imageView.image == nil {
            imageView.backgroundColor = .blue
        }
    }
    
    func displayContent(name: String, image: UIImage) {
        label.text = name
        imageView.image = image
    }
}
