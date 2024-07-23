//
//  DishCategoryEditInteractor.swift
//  Pardus
//
//  Created by Igor Postoev on 22.7.24.
//  
//

import Foundation
import UIKit

final class DishCategoryEditInteractor: DishCategoryEditInteractorProtocol {
    
    var category: DishCategoryModel?
    
    private let modelService: EntityModelServiceType
    private let categoryId: UUID?
    
    init(modelService: EntityModelServiceType, categoryId: UUID?) {
        self.modelService = modelService
        self.categoryId = categoryId
    }
    
    func loadCategory() async throws {
        if let categoryId {
            category = try await modelService.fetch(entityIds: [categoryId]).first
            return
        }
        category = try await modelService.create(model: DishCategoryModel(id: UUID(),
                                                                          name: "",
                                                                          colorHex: "AAAAAA",
                                                                          objectId: nil))
    }
    
    func save() async throws {
        try await modelService.save()
    }
    
    func update(name: String, color: UIColor) async throws {
        guard let category else {
            assertionFailure()
            return
        }
        try await modelService.update(models: [DishCategoryModel(id: category.id,
                                                                 name: name,
                                                                 colorHex: color.toHex(),
                                                                 objectId: category.objectId)])
    }
}

// MARK: Private
extension DishCategoryEditInteractor {
    
}
