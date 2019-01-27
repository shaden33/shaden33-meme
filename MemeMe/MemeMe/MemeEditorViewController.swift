//
//  MemeEditorViewController
//  MemeMe
//
//  Created by shaden on ٢ ربيع١، ١٤٤٠ هـ.
//  Copyright © ١٤٤٠ هـ shaden. All rights reserved.
// s.7393.shosho@hotmail.com

import UIKit

class MemeEditorViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate , UITextFieldDelegate{
    
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
 @IBOutlet weak var cancelButton: UIBarButtonItem!
    var memedImage : UIImage!
    
    
    let memeTextAttributes :[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -4.0 ]
    
    
    func setStyle(toTextField textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.autocapitalizationType = .allCharacters
        textField.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStyle(toTextField: topText)
        setStyle(toTextField: bottomText)
        ImageView?.contentMode = .scaleAspectFit
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        shareButton.isEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        shareButton.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func pickAnImage(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    @IBAction func fromCamera(_ sender: Any) {
        openImagePicker(.camera)
    }
    func openImagePicker(_ type: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    // to view
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String: Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            ImageView.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    // cancel
    @IBAction func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
 //   @IBAction func imagePickerControllerDidCancel(_ picker:UIImagePickerController) {
        //Picker.dismiss(animated: true, completion: nil)
    
    // picker.dismiss(animated: true, completion: nil)
  //  }
  //  @IBAction  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    
  //          picker.dismiss(animated: true, completion: nil)
 //   }
    
    
    /// keyboard :
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
        
    }
    @objc func keyboardWillHide(_ notification:NSNotification){
        if bottomText.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func hideToolbars(hide: Bool) {
        toolbar.isHidden = true
        navigationController?.isNavigationBarHidden = true
    }
    
    func save() {
        // Create the meme
        let meme = Meme (topText: topText.text!, bottomText: bottomText.text!, originalImage: ImageView.image!, memedImage: memedImage!)
    }
    
    func generateMemedImage() -> UIImage {
        hideToolbars(hide:true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        hideToolbars(hide:false)
        
        return memedImage
    }
    @IBAction func share () {
        
        memedImage = generateMemedImage()
        let activity = UIActivityViewController( activityItems: [memedImage], applicationActivities: nil)
        
        activity.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
            }
        }
        self.present(activity, animated: true, completion: nil)
        
    }
}
