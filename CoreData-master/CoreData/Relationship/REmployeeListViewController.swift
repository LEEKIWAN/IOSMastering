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

class REmployeeListViewController: UIViewController {
    var department: DepartmentEntity?
    var list = [EmployeeEntity]()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers.first as? RDepartmentComposerTableViewController {
            vc.department = department
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let employeeList = department?.employees?.allObjects as? [EmployeeEntity] else {
            return
        }
        
        list = employeeList.sorted(by: { (lhs, rhs) -> Bool in
            lhs.name! < rhs.name!
        })
        
        listTableView.reloadData()
        
    }
}

extension REmployeeListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let employee = list[indexPath.row]
        
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = employee.address
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            guard let dept = department else { fatalError() }            
            let employee = list[indexPath.row]
            
            dept.removeFromEmployees(employee)
            employee.department = nil
            
            DataManager.shared.saveMainContext()
            
            list.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            break
        default:
            break
        }
    }
}
