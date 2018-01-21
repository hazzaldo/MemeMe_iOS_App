//
//  SentMemesDetailController.swift
//  Meme_me_2.0
//
//  Created by Hareth Naji on 29/08/2016.
//  Copyright © 2016 Hazzaldo. All rights reserved.
//

import Foundation
import UIKit

class SentMemesDetailController : UIViewController {
    
    @IBOutlet weak var sentMemesDetailImage: UIImageView!
    var memes : SavedMemedImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sentMemesDetailImage!.image = memes.memedImage
    }
}
