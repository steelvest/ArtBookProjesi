//
//  detailVC.swift
//  ArtBookProject
//
//  Created by Oğuz Özgül on 26.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit
import CoreData

class detailVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    
    var chosenPainting = ""
    var chosenPaintingID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //EĞER GELEN VERİ VARSA
        if chosenPainting != "" {
            
        }
        
        
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
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func savebuttonClicked(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newpainting = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Ekleme
        newpainting.setValue(nameText.text, forKey: "name")
        newpainting.setValue(artistText.text, forKey: "artist")
        if let year = Int(yearText.text!) {
            newpainting.setValue(year, forKey: "year")
        }
        newpainting.setValue(UUID(), forKey: "id")
        let data = imageView.image!.jpegData(compressionQuality: 0.5)
        
        newpainting.setValue(data, forKey: "image")
        do {
            try context.save()
        } catch {
            print("Hata Var")
        }

        //Geri Git
        
        NotificationCenter.default.post(name: NSNotification.Name("yeniveri"), object: nil)
        self.navigationController?.popViewController(animated: true)
        
        
        
        
    }
}
