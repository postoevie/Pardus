//
//  EntityModelType.swift
//  Pardus
//
//  Created by Igor Postoev on 27.5.24..
//

import Foundation

protocol EntityModelType {
    var id: UUID { get }
    static var mapping: EntityModelMappingType { get }
}
