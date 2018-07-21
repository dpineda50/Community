//
//  Albums.swift
//  CoordinatorTest
//
//  Created by Daniel Pineda on 7/18/18.
//  Copyright © 2018 com.danielPineda. All rights reserved.
//

import Foundation
import UIKit

class Album : Hashable {
    var hashValue: Int {
        return path.hashValue
    }
    
    static func == (lhs: Album, rhs: Album) -> Bool {
        return lhs.title == rhs.title &&
                lhs.path == rhs.path
    }
    
    let title: String
    var image: UIImage!
    let path: String
    let coverImageURL: String?
    
    init(title: String, path: String, coverImageURL: String?, image: UIImage? = nil) {
        self.title = title
        self.path = path
        self.coverImageURL = coverImageURL
        self.image = image
    }
}
