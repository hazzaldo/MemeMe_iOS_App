//
//  SentMemesCollectionController.swift
//  Meme_me_2.0
//
//  Created by Hareth Naji on 29/08/2016.
//  Copyright © 2016 Hazzaldo. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionController : UICollectionViewController{
    
    // MARK: Class properties
    var memes : [SavedMemedImage] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
        
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    // MARK: Class methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let space: CGFloat = 3.0
        let lineSpace : CGFloat = 2.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (view.frame.size.height - ( space )) / 5.0
        
        flowLayout.minimumLineSpacing = lineSpace
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemesCollectionViewCell", for: indexPath) as! SentMemesCollectionViewCell
        let chosenMeme = memes[indexPath.row]
        cell.sentMemesCollectionCellImage?.image = chosenMeme.memedImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let sentMemesDetailController = self.storyboard?.instantiateViewController(withIdentifier: "SentMemesDetailController") as! SentMemesDetailController
        sentMemesDetailController.memes = memes[indexPath.row]
        self.navigationController?.pushViewController(sentMemesDetailController, animated: true)
    }
    
}
