//
//  Meme.swift
//  MemeMe
//
//  Created by Nikko on 3/16/17.
//  Copyright © 2017 Nikko Sanchez. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText1: String?
    var bottomText1: String?
    var originalImage1: UIImage?
    var memedImage1: UIImage?
    
    init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage? ) {
        topText1 = topText
        bottomText1 = bottomText
        originalImage1 = originalImage
        memedImage1 = memedImage
    }
    
}
