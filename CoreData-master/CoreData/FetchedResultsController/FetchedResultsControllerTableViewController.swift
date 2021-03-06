//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import CoreData

class FetchedResultsControllerTableViewController: UITableViewController {
    
    lazy var fetchRequest: NSFetchRequest<EmployeeEntity> = {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "Employee")
        
        request.predicate = NSPredicate(format: "department != NIL")
        
        let sorByDeptName = NSSortDescriptor(key: #keyPath(EmployeeEntity.department.name), ascending: true)
        let sortByName = NSSortDescriptor(key: "name", ascending: true)
        
        request.sortDescriptors = [sorByDeptName, sortByName]       // 데이터를 정렬 안하면 크레쉬 -> resultController
        
        request.fetchBatchSize = 30
        
        return request
    }()
    
    
    lazy var resultController: NSFetchedResultsController<EmployeeEntity> = { [weak self] in
        let controller = NSFetchedResultsController(fetchRequest: self!.fetchRequest, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: #keyPath(EmployeeEntity.department.name), cacheName: "CacheByDeptName")
        
        
        controller.delegate = self
        
        return controller
        }()
    
    
    @IBAction func showMenu(_ sender: Any) {
        showMenu()
    }
    
    
    func changeSortOrder() {
        NSFetchedResultsController<EmployeeEntity>.deleteCache(withName: resultController.cacheName)
        
        let sortByDeptName = NSSortDescriptor(key: "department.name", ascending: false)
        let sortBySalary = NSSortDescriptor(key: "salary", ascending: true)
        resultController.fetchRequest.sortDescriptors = [sortByDeptName, sortBySalary]
        
        do {
            try resultController.performFetch()
            tableView.reloadData()
        }
        catch {
            print(error)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try resultController.performFetch()
        }
        catch {
            print(error.localizedDescription)
        }
        
        //        NSFetchedResultsController<EmployeeEntity>.deleteCache(withName: "CacheByDeptName")
    }
    
    deinit {
        resultController.delegate = nil
    }
}

extension FetchedResultsControllerTableViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let insertIndexPath = newIndexPath {
                tableView.insertRows(at: [insertIndexPath], with: .automatic)
            }
        case .delete:
            if let deleteIndexPath = indexPath {
                tableView.deleteRows(at: [deleteIndexPath], with: .fade)
            }
        case .update:
            if let updateIndexPath = indexPath {
                tableView.reloadRows(at: [updateIndexPath], with: .fade)
            }
        case .move:
            if let originalIndexPath = indexPath, let targetIndexPath = newIndexPath {
                tableView.moveRow(at: originalIndexPath, to: targetIndexPath)
            }
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex) , with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


extension FetchedResultsControllerTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return resultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return resultController.sections?[section].name
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = resultController.sections else {
            return 0
        }
        
        let sectionInfo = sections[section]
        
        return sectionInfo.numberOfObjects
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = resultController.object(at: indexPath)
        
        cell.textLabel?.text = target.name
        cell.detailTextLabel?.text = target.department?.name
        
        return cell
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        resultController.sectionIndexTitles
    }
}


extension FetchedResultsControllerTableViewController {
    func showMenu() {
        let alert = UIAlertController(title: "Fetched Results Controller", message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add Employee", style: .default) { (action) in
            let context = DataManager.shared.mainContext
            
            let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
            newEmployee.setValue("Aaden Smith", forKey: "name")
            newEmployee.setValue(50, forKey: "age")
            
            DataManager.shared.saveMainContext()
        }
        alert.addAction(addAction)
        
        let deleteAction = UIAlertAction(title: "Delete Employee", style: .destructive) { (action) in
            let context = DataManager.shared.mainContext
            
            let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
            request.fetchLimit = 1
            
            let filterByName = NSPredicate(format: "name == %@", "Aaden Smith")
            request.predicate = filterByName
            
            let sortByName = NSSortDescriptor(key: "name", ascending: true)
            request.sortDescriptors = [sortByName]
            
            do {
                if let first = try context.fetch(request).first {
                    context.delete(first)
                    DataManager.shared.saveMainContext()
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        alert.addAction(deleteAction)
        
        let changeSortOrderAction = UIAlertAction(title: "Change Sort Order", style: .default) { (action) in
            self.changeSortOrder()
        }
        alert.addAction(changeSortOrderAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
}
