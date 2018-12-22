//
//  ShareViewController.swift
//  MemeProject
//
//  Created by Eyad alodah on 11/16/18.
//  Copyright © 2018 Eyad alodah. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    var memePic: MemeInformation?
    var memesinfo = [MemeInformation]()

    @IBOutlet weak var memedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       print(memePic?.buttomText)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        memedImage.image = memePic?.editedImage
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        let items = [memedImage.image]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if !completed {
                return
            }else{
                self.saveMeme()
            }
        }
        present(ac, animated: true)
    }
    
    
    func saveMeme() {
        let meme = MemeInformation(topText: (memePic?.topText)!, buttomText: (memePic?.buttomText)!, editedImage: (memePic?.editedImage)!, orignalImage: (memePic?.orignalImage)!)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        memesinfo = appDelegate.memes
        
        print("Size of the delegute")
        print(memesinfo.count)
        
       debugPrint("Meme Saved")
    }
    
}
