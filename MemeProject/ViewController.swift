//
//  ViewController.swift
//  MemeProject
//
//  Created by Eyad alodah on 11/14/18.
//  Copyright © 2018 Eyad alodah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var choosenImage: UIImageView!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    var memePic: MemeInformation?
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTextAttributes:[NSAttributedString.Key: Any] = [
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeColor.rawValue): UIColor.black,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): UIFont(name: "HelveticaNeue-Bold", size: 40)!,
        NSAttributedString.Key(rawValue: NSAttributedString.Key.strokeWidth.rawValue): -4.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setDefaultValuesForTextField(textField: topTextField)
        setDefaultValuesForTextField(textField: buttomTextField)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

    }
    
    func setDefaultValuesForTextField(textField: UITextField) {
        textField.defaultTextAttributes = memeTextAttributes
        textField.adjustsFontSizeToFitWidth =  true
        textField.textAlignment = .center
        textField.delegate = self
    }
    @IBAction func pickAnImage(_ sender:Any) {
        
        pickImageToPrepareMeme(sourceType: .photoLibrary)
    }
    
    
    @IBAction func pickAnImageFromCamera(_ sender:Any) {
        pickImageToPrepareMeme(sourceType: .camera)
        
    }
    
    
    func pickImageToPrepareMeme(sourceType: UIImagePickerController.SourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        present(pickerController, animated: true, completion: nil)
        print("we will save the image..")
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("Start of the conroller of the image")
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            choosenImage.image = image
        }
        print("inside")
        save()
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField.text != nil {
//            let text = textField.text! as NSString
//            let finalString = text.replacingCharacters(in: range, with: string)
//            textField.frame.size.width = getWidth(text: finalString)
//        }
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
   override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func getWidth(text: String) -> CGFloat
    {
        let txtField = UITextField(frame: .zero)
        txtField.text = text
        txtField.sizeToFit()
        return txtField.frame.size.width
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        debugPrint("Showing keyboard")
        if topTextField.isFirstResponder == false{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true;
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        print("Hiding keyboard")
        
        view.frame.origin.y = 0
    }

    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        if choosenImage.image != nil{
        let meme = MemeInformation(topText: topTextField.text!, buttomText: buttomTextField.text!, editedImage: generateMemedImage(), orignalImage: choosenImage.image!)
        
        memePic = meme
        print(meme.editedImage)
        }
        else{
            let alert  = UIAlertController(title: "Warning", message: "Please Choose an image or take it by camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func generateMemedImage() -> UIImage {
        toolBar.isHidden = true
        topToolBar.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        toolBar.isHidden = false
        topToolBar.isHidden = false
        return memedImage
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let memeDestination = segue.destination as! ShareViewController
        memeDestination.memePic = memePic
        print("Finshed preparing")
    }
    
    @IBAction func shareMemeAction(_ sender: Any) {
        save()
        let items = [memePic?.editedImage]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }else{
                self.saveMemeIntoList()
                self.dismiss(animated: true, completion: nil)

            }
        }
        present(ac, animated: true, completion: nil)
    }
    
    
    func saveMemeIntoList() {
        let meme = MemeInformation(topText: (memePic?.topText)!, buttomText: (memePic?.buttomText)!, editedImage: (memePic?.editedImage)!, orignalImage: (memePic?.orignalImage)!)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        debugPrint("Meme Saved")
    }
    
    @IBAction func cancelSave(_ sender: Any) {
        
        let message = UIAlertController(title: "Cancel editing?", message: nil, preferredStyle: .alert)
        
        message.addAction(UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction!) in
            self.dismiss(animated: true, completion: nil)})
        
        message.addAction(UIAlertAction(title: "Continue", style: .cancel)
        )
        
        present(message, animated: true, completion: nil)
        
    }
    
}

