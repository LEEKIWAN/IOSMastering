//
//  EmployeeEntity+CoreDataClass.swift
//  CoreData
//
//  Created by kiwan on 2020/02/27.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//
//

import Foundation
import CoreData

@objc(EmployeeEntity)
public class EmployeeEntity: PersonEntity {
//    public override func validateForInsert() throws {
//        try super.validateForInsert()
//
//    }
    
//    @objc func validateAge(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
//        guard let ageValue = value.pointee as? Int else {
//            return
//        }
//
//        if ageValue < 20 || ageValue > 50 {
//            let msg = "Age value must be between 20 and 50"
//            let code = ageValue < 20 ? NSValidationNumberTooSmallError : NSValidationNumberTooLargeError
//
//            let error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: msg])
//
//            throw error
//        }
//    }
//    
//    @objc func validateName(_value: AutoreleasingUnsafeMutablePointer<AnyObject?>) throws {
//
//    }
//    
//    func validateAgeWithDepartment() throws {
//        guard let deptName = department?.name, deptName == "Development" else {
//            return
//        }
//        
//        guard age < 30 else {
//            return
//        }
//            
//        let msg = "Ther Delvelpment department cannot have Employees under 30 yeas of age."
//        
//        let code = NSValidationInvalidAgeAndDepartment
//        let error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey : msg])
//        
//        throw error
//    }
//    
//    public override func validateForInsert() throws {
//        try super.validateForInsert()
//        try validateAgeWithDepartment()
//    }
//    
//    public override func validateForUpdate() throws {
//        try super.validateForUpdate()
//        try validateAgeWithDepartment()
//    }
}


public let NSValidationInvalidAgeAndDepartment = Int.max - 100
