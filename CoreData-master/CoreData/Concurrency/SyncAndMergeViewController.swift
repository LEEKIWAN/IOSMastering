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


class SyncAndMergeViewController: UIViewController {
    
    lazy var formatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = Locale(identifier: "en_US")
        f.numberStyle = .currency
        return f
    }()
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var mainContextSalaryLabel: UILabel!
    
    @IBOutlet weak var backgroundContextSalaryLabel: UILabel!
    
    var employeeInMainContext: EmployeeEntity?
    var employeeInBackgroundContext: EmployeeEntity?
    
    let mainContext = DataManager.shared.mainContext
    let backgroundContext = DataManager.shared.backgroundContext
    
    @IBAction func fetchIntoMainContext(_ sender: Any) {
        mainContext.perform {
            self.employeeInMainContext = DataManager.shared.fetchEmployee(in: self.mainContext)
            
            self.nameLabel.text = self.employeeInMainContext?.name
            self.mainContextSalaryLabel.text = self.formatter.string(for: self.employeeInMainContext?.salary)
        }
    }
    
    @IBAction func fetchIntoBackgroundContext(_ sender: Any) {
        backgroundContext.perform {
            self.employeeInBackgroundContext = DataManager.shared.fetchEmployee(in: self.backgroundContext)
            
            DispatchQueue.main.async {
                self.backgroundContextSalaryLabel.text = self.formatter.string(for: self.employeeInBackgroundContext?.salary?.decimalValue)
            }
            
        }
    }
    
    @IBAction func updateInMainContext(_ sender: Any) {
        mainContext.perform {
            let newSalary = NSDecimalNumber(integerLiteral: Int.random(in: 30...90) * 1000)
            self.employeeInMainContext?.salary = newSalary
            self.mainContextSalaryLabel.text = self.formatter.string(for: self.employeeInMainContext?.salary)
        }
    }
    
    @IBAction func updateInBackgroundContext(_ sender: Any) {
        backgroundContext.perform {
            let newSalary = NSDecimalNumber(integerLiteral: Int.random(in: 30...90) * 1000)
            self.employeeInBackgroundContext?.salary = newSalary
            DispatchQueue.main.async {
                self.backgroundContextSalaryLabel.text = self.formatter.string(for: self.employeeInBackgroundContext?.salary)
            }
        }
    }
    
    @IBAction func saveInMainContext(_ sender: Any) {
        mainContext.perform {
            do {
                try self.mainContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func saveInBackgroundContext(_ sender: Any) {
        backgroundContext.perform {
            do {
                try self.backgroundContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    @IBAction func refreshInMainContext(_ sender: Any) {
        mainContext.perform {
            self.mainContext.refresh(self.employeeInMainContext!, mergeChanges: true)
            
            self.mainContextSalaryLabel.text = self.formatter.string(for: self.employeeInMainContext?.salary)
        }
    }
    
    @IBAction func refreshInBackgroundContext(_ sender: Any) {
        backgroundContext.perform {
            self.backgroundContext.refresh(self.employeeInBackgroundContext!, mergeChanges: true)
            
            DispatchQueue.main.async {
                self.backgroundContextSalaryLabel.text = self.formatter.string(for: self.employeeInBackgroundContext?.salary)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainContext.mergePolicy = NSOverwriteMergePolicy
        backgroundContext.mergePolicy = NSOverwriteMergePolicy
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: OperationQueue.main) { (noti) in
            guard let userInfo = noti.userInfo else { return }
            guard let changedContext = noti.object as? NSManagedObjectContext else { return }
            
            print("===========================")
            
            if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
                
            }
            
            if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
                
            }
            
            if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
//                guard changedContext != self.backgroundContext else {
//                    return
//                }
//
//                for update in updates {
//                    self.backgroundContext.perform {
//                        for (key, value) in update.changedValues() {
//                            self.employeeInBackgroundContext?.setValue(value, forKey: key)
//                        }
//
//                        let salary = self.employeeInBackgroundContext?.salary?.decimalValue
//                        DispatchQueue.main.async {
//                            self.backgroundContextSalaryLabel.text = self.formatter.string(for: salary)
//                        }
//                    }
//                }
            }
            
        }
    }
}
