//
//  DMVC.swift
//  meme 0.1
//
//  Created by Albandry on 5/4/19.
//  Copyright © 2019 Albandry. All rights reserved.
//

import UIKit

class DMVC: UIViewController {

    
    @IBOutlet weak var imgView: UIImageView!
    
     
    var meme: Meme!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // hide tab bar
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // show tab bar on view disappears
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView.image = meme.memedImage
    }
   
    
    
    @IBAction func editAction(_ sender: Any) {
        
        let MemeEditorVC = storyboard!.instantiateViewController(withIdentifier: "MemeEditorVC") as! ViewController
        MemeEditorVC.sentmeme = self.meme
        self.navigationController?.pushViewController(MemeEditorVC, animated: true)
    }
    }
    

 
