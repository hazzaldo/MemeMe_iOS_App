//
//  SentMemesTableController.swift
//  Meme_me_2.0
//
//  Created by Hareth Naji on 29/08/2016.
//  Copyright © 2016 Hazzaldo. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableController : UITableViewController{
    
    // MARK: Class properties
    var memes : [SavedMemedImage] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Class methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //For deleting the Meme
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            (UIApplication.shared.delegate as! AppDelegate).memes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell", for: indexPath) as! SentMemesTableViewCell
        let chosenMeme = memes[indexPath.row]
        cell.sentMemesCellImage!.image = chosenMeme.memedImage
        cell.SentMemesCellTopText!.text = chosenMeme.topText
        cell.SentMemesCellBottomText!.text = chosenMeme.bottomText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let sentMemesDetailController = self.storyboard!.instantiateViewController(withIdentifier: "SentMemesDetailController") as! SentMemesDetailController
        sentMemesDetailController.memes = memes[indexPath.row]
        self.navigationController!.pushViewController(sentMemesDetailController, animated: true)
    }
}
