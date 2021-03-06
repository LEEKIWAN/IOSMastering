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

class AsyncFetchingTableViewController: UITableViewController {
    
    var list = [NSManagedObject]()
    
    @IBAction func fetch(_ sender: Any?) {
        let request = NSFetchRequest<EmployeeEntity>(entityName: "Employee")
        
        let sortByName = NSSortDescriptor(key: #keyPath(EmployeeEntity.name), ascending: true)
        request.sortDescriptors = [sortByName]
        
        let asyncRequest = NSAsynchronousFetchRequest<EmployeeEntity>(fetchRequest: request) { (result) in
            guard let list = result.finalResult else { return }
            self.list = list
            self.tableView.reloadData()
        }
        
        do {
            try DataManager.shared.mainContext.execute(asyncRequest)
            
//            list = try DataManager.shared.mainContext.fetch(request)
//            tableView.reloadData()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetch(nil)
//        tableView.reloadData()
    }
}


extension AsyncFetchingTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].value(forKey: "name") as? String
        
        return cell
    }
}
