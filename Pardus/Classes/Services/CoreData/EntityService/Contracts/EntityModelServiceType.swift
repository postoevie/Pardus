//
//  EntityServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 23.5.24.
//	
//

import Foundation

protocol EntityModelServiceType {
 
    func create<T: EntityModelType>(model: T) async throws -> T
    func fetch<T: EntityModelType>(entityIds: [UUID]) async throws -> [T]
    func fetch<T: EntityModelType>(predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)?) async throws -> [T]
    func update<T: EntityModelType>(models: [T]) async throws
    func delete<T: EntityModelType>(models: [T]) async throws
    func save() async throws
    func stash(view: Views)
}

extension EntityModelServiceType {
    
    func fetch<EntityModel: EntityModelType>(predicate: NSPredicate?, sortParams: (field: String, ascending: Bool)? = nil) async throws -> [EntityModel] {
       try await fetch(predicate: predicate, sortParams: sortParams)
    }
}
