//
//  CoreDataRecordsRestoreService.swift
//  Pardus
//
//  Created by Igor Postoev on 2.12.24..
//

final class RecordsRestoreService: RecordsRestoreServiceType {
    
    let coreDataService: CoreDataServiceType
    
    init(coreDataService: CoreDataServiceType) {
        self.coreDataService = coreDataService
    }
    
    func restoreRecords(snapshot: RecordsStateSnapshot) {
        do {
            try coreDataService.syncPerform { executor in
                
                // Restore records attributes
                try snapshot.dishCategories.forEach { uid, data in
                    let category = try executor.create(type: DishCategory.self, id: uid)
                    category.name = data.name
                }
                
                let dishes = try snapshot.dishes.map { uid, data in
                    let dish = try executor.create(type: Dish.self, id: uid)
                    dish.name = data.name
                    return dish
                }
                
                // Restore records relations
                for dish in dishes {
                    guard let categoryId = snapshot.dishes[dish.id]?.categoryId,
                          let category = try executor.fetchOne(type: DishCategory.self, predicate: .idIn(uids: [categoryId])) else {
                        continue
                    }
                    dish.category = category
                }
                
                try executor.persistChanges()
            }
        } catch {
            print("Error while restore records data: \(error)")
        }
    }
}

