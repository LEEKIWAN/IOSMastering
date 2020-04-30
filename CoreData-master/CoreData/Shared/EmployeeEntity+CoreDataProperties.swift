//
//  EmployeeEntity+CoreDataProperties.swift
//  CoreData
//
//  Created by kiwan on 2020/02/27.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//
//

import Foundation
import CoreData


extension EmployeeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeEntity> {
        return NSFetchRequest<EmployeeEntity>(entityName: "Employee")
    }

    @NSManaged public var contact: Contact?
    @NSManaged public var photo: Data?
    @NSManaged public var salary: NSDecimalNumber?
    @NSManaged public var department: DepartmentEntity?

}
