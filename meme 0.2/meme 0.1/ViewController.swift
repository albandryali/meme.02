//
//  ViewController.swift
//  meme
//
//  Created by Albandry on 4/11/19.
//  Copyright © 2019 Albandry. All rights reserved.
//

import UIKit

class ViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topButton: UITextField!
    @IBOutlet weak var bottomButton: UITextField!
    @IBOutlet weak var imageviewer: UIImageView!
    @IBOutlet weak var navtoolbar: UIToolbar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    @IBOutlet weak var share: UIBarButtonItem!
    
    var sentmeme: Meme?
    
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor:UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack" , size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField(tf: topButton, text: "TOP")
        setupTextField(tf: bottomButton, text: "BOTTOM")
    }
    
    func setupTextField(tf: UITextField, text: String) {
        tf.defaultTextAttributes = [
            NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue) : UIColor.white,
            NSAttributedString.Key.strokeColor.rawValue : UIColor.black,
            NSAttributedString.Key.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth.rawValue: -4.0,
            ] as! [NSAttributedString.Key : Any]
        tf.textColor = UIColor.white
        tf.tintColor = UIColor.white
        tf.textAlignment = .center
        tf.text = text
        tf.delegate = self
    }
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    //
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    
    
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil) }
    
    
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomButton.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)}}
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if bottomButton.isFirstResponder {
            view.frame.origin.y = 0}
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""}
    
    
    func chooseImageFromCameraOrPhoto(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(_ sender:Any) {
        chooseImageFromCameraOrPhoto(source: .photoLibrary)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageviewer.image = image
            imageviewer.contentMode = .scaleAspectFit
            share.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        chooseImageFromCameraOrPhoto(source: .camera)
    }
    
    
    
    
    
    
    func save() {
        // Create the meme
        let meme = Meme(topText: topButton.text!, bottomText: bottomButton.text!, originalImage: imageviewer.image!, memedImage: generateMemedImage())
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
        
    }
    
    func hidetoolbar(hide: Bool) {
        
        toolbar.isHidden = hide
        navtoolbar.isHidden = hide  }
    
    
    
    func generateMemedImage() -> UIImage {
        
        hidetoolbar(hide: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hidetoolbar(hide: false)
        
        return memedImage
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func share(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        let vc = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        vc.completionWithItemsHandler = { activity, processed, items, error in
            if processed == true
            { self.save()
                self.dismiss(animated: true, completion: nil)
            }}
        present(vc, animated: true, completion: nil)
        
    }
}


