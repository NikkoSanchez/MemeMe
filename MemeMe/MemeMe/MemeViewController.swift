//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Nikko on 3/8/17.
//  Copyright © 2017 Nikko Sanchez. All rights reserved.
//

import UIKit

struct Meme {
    var topText1: String?
    var bottomText1: String?
    var originalImage1: UIImage?
    var memedImage1: UIImage?
    
    init(topText: String?, bottomText: String?, originalImage: UIImage?, memedImage: UIImage? ) {
        topText1 = topText
        bottomText1 = bottomText
        originalImage1 = originalImage
        memedImage1 = memedImage
    }
    
}

class MemeViewController: UIViewController {

    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    var memedImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldAttributes()
        shareButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func albumButtonTapped(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func textFieldAttributes() {
        let alignment = NSMutableParagraphStyle()
        alignment.alignment = .center
        
        let memeTextAttributes: [String: Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSParagraphStyleAttributeName: alignment,
            NSStrokeWidthAttributeName: -1.0
        ]
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    @IBAction func shareButtonTapped(_ sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        imagePickerView.image = memedImage
        let sharingItems = [imagePickerView.image]
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.present(activityViewController, animated: true) { [weak self] in
            self?.save()
        }
    }
    
    func save() {
        let meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, originalImage: imagePickerView.image, memedImage: memedImage)
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        topTextField.text = "Top"
        bottomTextField.text = "Bottom"
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        guard let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        toolbar.isHidden = false
        return memeImage
    }
    // MARK: Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(_ notification: NSNotification) {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    func getKeyboardHeight(_ notification: NSNotification) -> CGFloat {
        guard let userInfo = notification.userInfo else { return CGFloat() }
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }

}

extension MemeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension MemeViewController: UINavigationControllerDelegate {

}

extension MemeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
