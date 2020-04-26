//
//  ViewController.swift
//  ArtBookProject
//
//  Created by Oğuz Özgül on 26.04.2020.
//  Copyright © 2020 Oğuz Özgül. All rights reserved.
//

import UIKit
import CoreData
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var nameArray = [String]()
    var idArray = [UUID]()
    
    var selectedPainting = ""
    var selectedPaintingID : UUID?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.topItem?.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClick))
        getData()
        
    }
    
   @objc func getData() {
    
    nameArray.removeAll(keepingCapacity: false)
    idArray.removeAll(keepingCapacity: false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetcRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        fetcRequest.returnsObjectsAsFaults = false
        do {
            let results =  try context.fetch(fetcRequest)
            
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                self.tableView.reloadData()
            }
        }catch{
            print("Hata Var")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,  selector: #selector(getData), name: NSNotification.Name(rawValue : "yeniveri"), object: nil)
    }
    
    @objc func addButtonClick() {
        selectedPainting = ""
        performSegue(withIdentifier: "toDeatilVC", sender: nil)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = nameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDeatilVC" {
            let destinacitonVC = segue.destination as! detailVC
            destinacitonVC.chosenPainting = selectedPainting
            destinacitonVC.chosenPaintingID = selectedPaintingID
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPainting = nameArray[indexPath.row]
        selectedPaintingID = idArray[indexPath.row]
        performSegue(withIdentifier: "toDeatilVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let appDelegate =  UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetcRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            let idString = idArray[indexPath.row].uuidString
            fetcRequest.predicate = NSPredicate(format: "id= %@", idString)
            fetcRequest.returnsObjectsAsFaults = false
            do  {
                let results = try context.fetch(fetcRequest)
                if results.count > 0 {
                    for result in results as! [NSManagedObject] {
                        if let id = result.value(forKey: "id")  as? UUID {
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                nameArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                do {
                                    try context.save()

                                }catch {
                                    print("Hata Mesajı")
                                }
                                break
                            }
                        }
                       
                    }
                    
                }
            }catch {
            print("Hata Mesajı")
            
        }
    }
}
}
