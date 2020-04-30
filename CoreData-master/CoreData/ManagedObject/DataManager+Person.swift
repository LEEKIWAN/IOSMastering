//
//  DataManager+Person.swift
//  CoreData
//
//  Created by kiwan on 2020/02/24.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//

import Foundation
import CoreData

extension DataManager {
    func createPerson(name: String, age: Int? = nil, completion: (() -> ())? = nil) {
        mainContext.perform {
            let newPerseon = PersonEntity(context: self.mainContext)
            newPerseon.name = name
            if let age = age {
                newPerseon.age = Int16(age)
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    
    func fetchPerson() -> [PersonEntity] {
        var list = [PersonEntity]()
        mainContext.performAndWait {
            let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
            
            let sortByName = NSSortDescriptor(key: #keyPath(PersonEntity.name), ascending: true)
            
            request.sortDescriptors = [sortByName]
            
            do {
                list = try mainContext.fetch(request)
            }
            catch {
                print(error)
            }
        }
        
        return list
    }
    
    func updatePerson(entity: PersonEntity, name: String, age: Int? = nil, completion: (() -> ())? = nil) {
        mainContext.perform {
            entity.name = name
            if let age = age {
                entity.age = Int16(age)
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    func delete(entity: PersonEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}
