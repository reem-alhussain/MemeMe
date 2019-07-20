//
//  MemeDetails_VC.swift
//  MemeMe
//
//  Created by Reem on 27/04/2019.
//  Copyright © 2019 Reem. All rights reserved.
//

import UIKit

class MemeDetails_VC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var memeImageView: UIImageView!
    
    // MARK: - Variables
    var detailMeme: Meme!
    
    // MARK: - VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()

       memeImageView.image = detailMeme.memedImage
    }
    

}
