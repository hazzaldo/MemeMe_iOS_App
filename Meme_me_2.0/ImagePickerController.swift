//
//  ImagePickerController.swift
//  Meme_me_1.0
//
//  Created by Hareth Naji on 30/04/2016.
//  Copyright © 2016 Hazzaldo. All rights reserved.
//

import UIKit

class ImagePickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Class properties
    var defaultTopFontKey : String? = UserDefaults.standard.string(forKey: "topTextfieldFontType")
    var defaultBottomFontKey : String? = UserDefaults.standard.string(forKey: "bottomTextfieldFontType")
    var savedMeme : SavedMemedImage!
    let imagePicker = UIImagePickerController()
    var scrollView: UIScrollView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    var textFieldHeight : CGFloat?
    var currentKeyboardHeight: CGFloat = 0.0
    
    // MARK: Class methods
    
    //Home button
    @IBAction func homeAction(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkFontType (textField: UITextField, fontTypeKey: String?){
        defaultTopFontKey = UserDefaults.standard.string(forKey: "topTextfieldFontType")
        defaultBottomFontKey = UserDefaults.standard.string(forKey: "bottomTextfieldFontType")
        //checking font type setting
        if let defaultFtKey = fontTypeKey {
            textField.font = UIFont(name: "\(defaultFtKey)", size: 20)
        }else{
            textField.font = UIFont(name: "Impact", size: 20)
        }
    }
    
    func imagePickingOption(picker: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = picker
        present(imagePicker, animated: true, completion: nil)
    }
    
    //pick an image from an album
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
        imagePickingOption(picker: .photoLibrary)
    }
    
    //pick camera
    @IBAction func pickCamera (sender: AnyObject) {
        imagePickingOption(picker: .camera)
    }
    
    func generateMemedImage() -> UIImage{
        //Hide Nav and tool bar
        toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //Hide Nav and tool bar
        toolBar.isHidden = false
        return memedImage
    }
    
    //Share button
    @IBAction func shareAction(sender: UIBarButtonItem) {
        let contextMemedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [contextMemedImage], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if (success){
                self.save()
                print("Activity: \(String(describing: activity)) Success: \(success) Items: \(String(describing: items)) Error: \(String(describing: error))")
                print ("ViewController - image saved successfully")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
 

    func save () {
        
        //Update the meme
        let contextMemedImage = generateMemedImage()
        savedMeme = SavedMemedImage (topText:topText.text!, bottomText: bottomText.text!, originalImage: imagePickerView.image!, memedImage: contextMemedImage)
        
        // Add it to the memes array in the Application Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(savedMeme)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //checking whether the device/emulator has a camera
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        //checking font type setting
        checkFontType(textField: topText, fontTypeKey: defaultTopFontKey)
        checkFontType(textField: bottomText, fontTypeKey: defaultBottomFontKey)
    }
    
    func toggleImagePickerUI (hasImage: Bool){
        if hasImage{
            topText.isHidden = !hasImage
            bottomText.isHidden = !hasImage
            instructionLabel.isHidden = true
            shareButton.isEnabled = true
        } else {
            topText.isHidden = true
            bottomText.isHidden = true
            instructionLabel.isHidden = false
            shareButton.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if imagePickerView.image == nil {
            toggleImagePickerUI(hasImage: false)
        }
        //checking font type setting
        checkFontType(textField: topText, fontTypeKey: defaultTopFontKey)
        checkFontType(textField: bottomText, fontTypeKey: defaultBottomFontKey)
    }
    
    @IBAction func bottomTextFieldAction(sender: UITextField) {
        subscribeToKeyboardNotifications()
    }
    
    @IBAction func bottomTextFieldFinishedEdit(sender: UITextField) {
        unsubscribeFromKeyboardNotifications()
    }

    
    func prepareTextField(textField: UITextField, defaultText: String) {
        super.viewDidLoad()
        let memeTextAttributes : [String : Any] = [
            NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
            NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
            NSAttributedStringKey.font.rawValue : UIFont(name: "HelveticaNeue-CondensedBlack", size: 35)!,
            NSAttributedStringKey.strokeWidth.rawValue : -2.0
            ]
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = defaultText
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldHeight = topText.frame.height
        imagePicker.delegate = self
        cancelButton.isEnabled = true
        //checking font type setting
        checkFontType(textField: topText, fontTypeKey: defaultTopFontKey)
        checkFontType(textField: bottomText, fontTypeKey: defaultBottomFontKey)
        prepareTextField(textField: topText, defaultText: "TOP")
        prepareTextField(textField: bottomText, defaultText: "BOTTOM")
        toggleImagePickerUI(hasImage: false)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                                 didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.contentMode = .scaleAspectFit
            imagePickerView.image = image
    }
        dismiss(animated: true, completion: nil)
        toggleImagePickerUI(hasImage: true)
        //reset text fields back to top and bottom texts
        prepareTextField(textField: topText, defaultText: "TOP")
        prepareTextField(textField: bottomText, defaultText: "BOTTOM")
    }
    
    @IBAction func topTxtFieldEditing(sender: UITextField) {
        resizeTextField(textField: sender)
    }
   
    
    @IBAction func bottomTxtFieldEditing(sender: UITextField) {
        resizeTextField(textField: sender)
    }
    
    
    //ViewController unsubscribes to keyboard notification
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    //ViewController subscribes to keyboard notification
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide) , name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
       // NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Home.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //Sends notification when the keyboard disappears and push view back down
    @objc func keyboardWillHide (notification: NSNotification){
        view.frame.origin.y = 0
    }
    
    
    //Sends notification when the keyboard appears and push view above keyboard
    @objc func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    

    //Get the height of the keyboard
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        let keyboardHeight = keyboardSize.cgRectValue.height
        currentKeyboardHeight = keyboardHeight
        return currentKeyboardHeight
    }
    
    //this will resize the textfield accodring to the length of the string as you're typing
    func resizeTextField(textField: UITextField) {
        /// Calculate & resize width
        let myString: NSString = textField.text! as NSString
        let size: CGSize = myString.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14.0)])
        let padding: CGFloat = 20.0
        let center = view.frame.width / 2
        let frameRect = CGRect(x: center - (size.width + padding) / 2, y: textField.frame.origin.y , width: size.width + padding, height: textFieldHeight!)
        textField.frame = frameRect
    }
}


extension ImagePickerController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newNum : NSString
        newNum = textField.text! as NSString
        newNum = newNum.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
