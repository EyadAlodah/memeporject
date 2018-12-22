//
//  ShowMemeViewController.swift
//  MemeProject
//
//  Created by Eyad alodah on 12/11/18.
//  Copyright © 2018 Eyad alodah. All rights reserved.
//

import UIKit

class ShowMemeViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var meme: MemeInformation!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        image.image = meme.editedImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
