//
//  CategoriesListDataItem.swift
//  Pardus
//
//  Created by Igor Postoev on 13.11.24..
//

struct CategoriesListDataItem<MainEntity, DetailEntity> {
    
    let mainEntity: MainEntity?
    let detailEntities: [DetailEntity]
}

