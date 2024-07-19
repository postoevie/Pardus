//
//  EntityModelMappingType.swift
//  Pardus
//
//  Created by Igor Postoev on 26.5.24..
//

import CoreData

protocol EntityModelMappingType {
    
    func createObject(context: NSManagedObjectContext, model: EntityModelType) throws -> EntityModelType
    func createModel(managedObject: NSManagedObject) throws -> EntityModelType
    func fill(managedObject: NSManagedObject, with model: EntityModelType) throws
    func getMOName() throws -> String
}
