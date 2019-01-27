//
//  meme.swift
//  MemeMe
//
//  Created by shaden on ١٠ ربيع١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ shaden. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var ImageView: UIImage
    var memedImage: UIImage!
    
    init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.ImageView = originalImage
        self.memedImage = memedImage
    }

}
