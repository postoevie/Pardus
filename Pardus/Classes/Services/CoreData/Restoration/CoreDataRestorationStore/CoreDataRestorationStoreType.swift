//
//  CoreDataRestorationStoreType.swift
//  Pardus
//
//  Created by Igor Postoev on 31.5.24.
//	
//

import Foundation

protocol CoreDataRestorationStoreType {
	
    func restore(key: Views) -> CoreDataRestorationItem?
    func store(key: Views, item: CoreDataRestorationItem)
}
