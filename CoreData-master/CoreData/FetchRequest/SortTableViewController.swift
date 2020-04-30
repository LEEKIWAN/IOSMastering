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

class SortTableViewController: UITableViewController {
    
    var list = [EmployeeEntity]()
    
    @IBAction func showMenu(_ sender: Any) {
        showSortMenu()
    }
    
    func sortByNameASC() {
        let sortByNameASC = NSSortDescriptor(key: #keyPath(EmployeeEntity.name), ascending: true)
        fetch(sortDescriptors: [sortByNameASC])
    }
    
    func sortByNameDESC() {
        let sortByNameDESC = NSSortDescriptor(key: #keyPath(EmployeeEntity.name), ascending: false)
        fetch(sortDescriptors: [sortByNameDESC])
    }
    
    func sortByAgeThenBySalary() {
        let sortByAge = NSSortDescriptor(key: #keyPath(EmployeeEntity.age), ascending: true)
        let sortBySalary = NSSortDescriptor(key: #keyPath(EmployeeEntity.salary), ascending: false)
        
        fetch(sortDescriptors: [sortByAge, sortBySalary])
    }
    
    func fetch(sortDescriptors: [NSSortDescriptor]? = nil) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "Employee")
        
        request.sortDescriptors = sortDescriptors
        
        do {
            list = try DataManager.shared.mainContext.fetch(request)
            tableView.reloadData()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch()
    }
}


extension SortTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = list[indexPath.row]
        if let name = target.name, let salary = target.salary?.intValue {
            cell.textLabel?.text = "[$\(salary)] \(name)"
        }
        
        cell.detailTextLabel?.text = "\(target.age)"
        
        return cell
    }
}


extension SortTableViewController {
    func showSortMenu() {
        let alert = UIAlertController(title: "Sort", message: "Select sort type", preferredStyle: .alert)
        
        let nameASC = UIAlertAction(title: "name ASC", style: .default) { (action) in
            self.sortByNameASC()
        }
        alert.addAction(nameASC)
        
        let nameDESC = UIAlertAction(title: "name DESC", style: .default) { (action) in
            self.sortByNameDESC()
        }
        alert.addAction(nameDESC)
        
        let ageAndSalary = UIAlertAction(title: "age ASC salary DESC", style: .default) { (action) in
            self.sortByAgeThenBySalary()
        }
        alert.addAction(ageAndSalary)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}
