//
//  ViewController.swift
//  MemeMe
//
//  Created by Reem on 12/04/2019.
//  Copyright © 2019 Reem. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    // MARK: - Outlets
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var imageView: UIImageView!
    
    

    // MARK: - Variables
    let memeTextAttributes :  [NSAttributedString.Key : Any]  = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Impact", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]
    
    
    
    // MARK: - VC Functions
    override func viewDidLoad() {
        super.viewDidLoad()

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false

        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func hideToolbar(_ hidden: Bool) {
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }

    
    
    // MARK: - Actions
    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        shareButton.isEnabled = false
        imageView.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        dismiss(animated: true, completion: nil)

    }
    @IBAction func shareMeme(_ sender: UIBarButtonItem) {
        let memeImage: UIImage = generateMeme()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {( type, ok, items, error ) in
            if ok {
                self.saveMeme(memeImage)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }
    @IBAction func pickImage(_ sender: Any) {
        
        let button = sender as! UIBarButtonItem
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
//        imagePicker.allowsEditing = true
        imagePicker.sourceType = button.tag == 0 ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    // MARK: - Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func saveMeme(_ memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        dismiss(animated: true, completion: nil)
    }
    func generateMeme() -> UIImage {
        
        // Hide toolbar and navbar
        hideToolbar(true)
        
        // Capture entire screen in image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        var memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Create a rect from imageView container view bounds
        let rect: CGRect = imageContainer.bounds
        let scale = memedImage.scale
        let scaledRect = CGRect(x: imageContainer.frame.origin.x * scale, y: imageContainer.frame.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        
        // Crop captured screen with rect created above and return just the contents of the image container view
        if let cgImage = memedImage.cgImage?.cropping(to: scaledRect) {
            memedImage = UIImage(cgImage: cgImage, scale: scale, orientation: .up)
        }
        
        // Show toolbar and navbar
        hideToolbar(false)
        
        return memedImage
        
        
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    
    
    
    // MARK: - Notification & Keyboard
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomTextField.isEditing{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    
   
}

