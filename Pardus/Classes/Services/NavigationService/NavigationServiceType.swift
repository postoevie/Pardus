//
//  NavigationServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//  
//

import Foundation

protocol NavigationServiceType: ObservableObject, Identifiable {
    var items:[Views] { get set }
    var modalView: Views? { get set }
    var alert: CustomAlert? { get set }
}
