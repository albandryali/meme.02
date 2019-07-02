//
//  CollectionViewController.swift
//  meme 0.1
//
//  Created by Albandry on 5/4/19.
//  Copyright © 2019 Albandry. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class CollectionViewController: UICollectionViewController   {
    
    
    
   
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        
    }

  
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCViewCell", for: indexPath) as! MemeCViewCell
        
        let meme = memes[indexPath.item]
        cell.imageviewcc.image = meme.memedImage
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let controller = self.storyboard!.instantiateViewController(withIdentifier: "DetailMemeVC") as! DMVC
        controller.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(controller, animated: true)
    }

}
