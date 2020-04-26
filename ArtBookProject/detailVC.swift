//
//  detailVC.swift
//  ArtBookProject
//
//  Created by Oğuz Özgül on 26.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit

class detailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        let gestureRecorganizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboadar))
        view.addGestureRecognizer(gestureRecorganizer)
        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let imageTaprecorganizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageTaprecorganizer)
    }
    
    //KLAVYE KAPATMA
    @objc func hideKeyboadar() {
        view.endEditing(true)
    }
    
    @objc func selectImage() {
        
    }
    @IBAction func savebuttonClicked(_ sender: Any) {
        
    }
}
