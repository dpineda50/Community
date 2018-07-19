//
//  PhotoCell.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/15/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import Firebase
import UIKit

class Photo {
    let url: URL!
    var image: UIImage!
    
    init(url: URL, image: UIImage? = nil) {
        self.url = url
        self.image = image
    }
}
