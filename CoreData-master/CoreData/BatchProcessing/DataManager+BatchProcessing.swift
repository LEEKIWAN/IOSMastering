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

import Foundation
import CoreData

extension DataManager {
    func batchUpdate() {
        let update = NSBatchUpdateRequest(entityName: "Task")
        update.propertiesToUpdate = [#keyPath(TaskEntity.done) : true]
        update.predicate = NSPredicate(format: "%K == NO", #keyPath(TaskEntity.done))
        update.resultType = .updatedObjectsCountResultType
        
        do {
            if let result = try mainContext.execute(update) as? NSBatchUpdateResult, let cnt = result.result as? Int {
                print("Updated: \(cnt)")
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func batchDelete() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
        
        request.predicate = NSPredicate(format: "%K == YES", #keyPath(TaskEntity.done))
        
        
        let delete = NSBatchDeleteRequest(fetchRequest: request)
        delete.resultType = .resultTypeCount
        
        
        do {
            if let result = try mainContext.execute(delete) as? NSBatchDeleteResult, let cnt = result.result as? Int {
                print("Deleted : \(cnt)")
            }
        }
        catch {
            print(error)
        }
    }
    
    func batchInsert() {
        mainContext.perform {
            for index in 0 ..< 10_000 {
                let newTask = TaskEntity(context: self.mainContext)
                newTask.task = "Task \(index + 1)"
                newTask.date = Date().addingTimeInterval(TimeInterval(3600 * 24 * Int.random(in: -365 ... 365)))
                
                if index % 1_000 == 0 {
                    do {
                        try self.mainContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            
            do {
                try self.mainContext.save()
                print("Inserted")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
