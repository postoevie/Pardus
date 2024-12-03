//
//  NavigationServiceType.swift
//  Pardus
//
//  Created by Igor Postoev on 11.5.24.
//
//

import Foundation
import Combine

protocol NavigationServiceType: ObservableObject, Identifiable {
    
    var tab: Tabs { get set }
    var mealsItems: [Views] { get set }
    var dishesItems: [Views] { get set }
    var ingridientsItems: [Views] { get set }
    var modalView: Views? { get set }
    var alert: CustomAlert? { get set }
    var sheetView: Views? { get set }
}
