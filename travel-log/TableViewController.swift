//
//  TableViewController.swift
//  travel-log
//
//  Created by Eunseo Lee and Karen Ren on 4/20/22.
//

import UIKit

class TableViewController: UITableViewController {

    var placeList :[LogObject] = []
    var loc = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        getPlaces()
    }//viewDidLoad()
    
    func getPlaces() {
        if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
            if let core =  try? context.fetch(LogObject.fetchRequest()) as [LogObject] {
                placeList = core
                tableView.reloadData()
            }//if let core
        }//if let context
    }//getPlaces()
  

    override func viewWillAppear(_ animated: Bool) {
        getPlaces()
    }//viewWillAppear
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeList.count
    }//tableView

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath)

        let title = placeList[indexPath.row].placeName
        cell.textLabel?.text = title
        return cell
    }//tableView: UITableView, cellForRowAt
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        loc = indexPath.row
        performSegue(withIdentifier: "EditSegue", sender: placeList[indexPath.row])
    }//didSelectRowAt

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let place = placeList[indexPath.row]
            
            if let context = (UIApplication.shared.delegate as?AppDelegate)?.persistentContainer.viewContext{
                context.delete(place)
                try? context.save()
                getPlaces()
            }//if
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }//else if
    }//tableView commit editingStyle:
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  let editVC = (segue.destination as? EditViewController) {
            let place = sender as! LogObject
            editVC.place = place
            editVC.loc = loc
            editVC.prevVC = self
        }//if  let editVC
        else if  let editVC = (segue.destination as? AddViewController) {
            editVC.prevVC = self
        }//else if  let
    }//prepare

}//TableViewController
