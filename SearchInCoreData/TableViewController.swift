//
//  TableViewController.swift
//  SearchInCoreData
//
//  Created by Saleh Omar Ahmed on 21/02/2022.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    //App Container
    var arrayContainer = [TheClass_a]()
    //Access to app delegate
    let constantContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext


    override func viewDidLoad() {
        super.viewDidLoad()
        functionLoadProcess()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return arrayContainer.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let constantObjCell = tableView.dequeueReusableCell(withIdentifier: "cri", for: indexPath)
        let constantCellContent = arrayContainer[indexPath.row]
        constantObjCell.textLabel?.text = constantCellContent.myAttributeTitle
        constantObjCell.accessoryType = constantCellContent.myAttributeStatus ? .checkmark : .none
        return constantObjCell
    }
    // MARK: - Selected Row
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        arrayContainer[indexPath.row].myAttributeStatus = !arrayContainer[indexPath.row].myAttributeStatus
        functionSaveProcess()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Add Operation
    @IBAction func AddTask(_ sender: UIBarButtonItem) {
        
        /* 6 */var globalVariableAddTask = UITextField()
        /* 1 */let constantAlert = UIAlertController(title: "Welcom", message: "Add new taks", preferredStyle: .alert)
        /* 2 */let constantAlertButton = UIAlertAction(title: "Add", style: .default) {
            (_) in
            // 7 { Adding and saving
            // A - Create object of class to get access to attributes to assing value
            /* [        */ let constantObjNewAddProcess = TheClass_a(context: self.constantContext)
            /*          */ constantObjNewAddProcess.myAttributeTitle = globalVariableAddTask.text!
            /* ]        */ constantObjNewAddProcess.myAttributeStatus = false
            // B - Add the Object to array
            self.arrayContainer.append(constantObjNewAddProcess)
            // C - Save The Object to Core data
            self.functionSaveProcess()
            // End of 7 }
        }
        /* 3 */ constantAlert.addTextField {
            (closuresParameterTextField) in
            closuresParameterTextField.placeholder = "The Task"
            globalVariableAddTask = closuresParameterTextField
        }
        /* 4 */ constantAlert.addAction(constantAlertButton)
        /* 5 */ present(constantAlert, animated: true, completion: nil)
    }
    // MARK: - Sub - Add Operation // Save and Load
    func functionSaveProcess(){
        do {
            try constantContext.save()
        }
        catch {
            print("Error saving context: \(error)")
        }
        tableView.reloadData()
    }
    func functionLoadProcess(with request: NSFetchRequest<TheClass_a> = TheClass_a.fetchRequest()) {
        
        do {
            arrayContainer = try constantContext.fetch(request)
        }
        catch {
            print("Error loading context:\(error)")
        }
        tableView.reloadData()
    }
}

//MARK: - Search Operations
extension TableViewController : UISearchBarDelegate  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<TheClass_a> = TheClass_a.fetchRequest()
        request.predicate = NSPredicate(format: "myAttributeTitle CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "myAttributeTitle", ascending: true)]
        functionLoadProcess(with: request)
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text?.count == 0 {
            functionLoadProcess()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
