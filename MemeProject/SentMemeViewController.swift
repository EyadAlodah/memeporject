//
//  SentMemeViewController.swift
//  MemeProject
//
//  Created by Eyad alodah on 12/10/18.
//  Copyright © 2018 Eyad alodah. All rights reserved.
//

import UIKit

class SentMemeViewController: UITableViewController{
    
    var memes: [MemeInformation] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }

    
    override func viewDidLoad() {
        
        print(memes.count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell")!
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        cell.imageView?.image =  meme.editedImage
        cell.textLabel?.text = meme.topText
       
        
        return cell
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "ShowMemeView") as! ShowMemeViewController
        
        controller.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(controller, animated: true)
    }
    
    
}

