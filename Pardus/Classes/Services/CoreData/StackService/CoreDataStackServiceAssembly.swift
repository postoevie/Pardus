//
//  CoreDataStackServiceAssembly.swift
//  Pardus
//
//  Created by Igor Postoev on 19.5.24.
//	
//

import Foundation

class CoreDataStackServiceAssembly: Assembly {
    
    static let service: CoreDataStackServiceType = CoreDataStackService()
    
    func build() -> CoreDataStackServiceType {
        return CoreDataStackServiceAssembly.service
    }
}
