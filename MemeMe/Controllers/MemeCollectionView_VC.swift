//
//  MemeCollectionView_VC.swift
//  MemeMe
//
//  Created by Reem on 27/04/2019.
//  Copyright © 2019 Reem. All rights reserved.
//

import UIKit

class MemeCollectionView_VC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        collectionView.reloadData()
    }
    
    func showEmptyView(_ show: Bool) {
        if show {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView!.frame.width, height: collectionView!.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "No Memes Stored!\nClick '+' to create a new Meme."
            collectionView!.backgroundView = label
        } else {
            collectionView!.backgroundView = nil
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCollectionMemeDetails" {
            if let cell = sender as? MemeCollectionViewCell {
                let destination = segue.destination as! MemeDetails_VC
                destination.detailMeme = appDelegate.memes[(collectionView?.indexPath(for: cell)?.row)!]
            }
        }
    }
 

}


extension MemeCollectionView_VC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        appDelegate.memes.count == 0 ? showEmptyView(true) : showEmptyView(false)
        return appDelegate.memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionCell", for: indexPath) as! MemeCollectionViewCell
        cell.memeImageView.image = appDelegate.memes[indexPath.row].memedImage
        return cell
    }
    
    
    
}
