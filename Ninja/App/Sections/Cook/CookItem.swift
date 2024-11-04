//
//  CookItem.swift
//  Ninja
//
//  Created by Martin Burch on 12/27/22.
//

import UIKit
import Combine

class CookItem  {
        
    var cell: CookControlsViewCell.Type = CookControlsViewCell.self
    var title: String?
    var identifier: String
    var onNavigate: ((UINavigationController, UIViewController) -> Void)?
    var onClick: ((UIControl, Any?) -> Void)?

    init(cell: CookControlsViewCell.Type,
         title: String? = nil,
         identifier: String = "",
         onNavigate: ((UINavigationController, UIViewController) -> Void)? = nil,
         onClick: ((UIControl, Any?) -> Void)? = nil) {
        self.cell = cell
        self.title = title
        self.identifier = identifier
        self.onNavigate = onNavigate
        self.onClick = onClick
    }
}

class CookCellItem<T>: CookItem {
    
    var enabledSubject: CurrentValueSubject<Bool, Never>?
    var currentValueSubject = CurrentValueSubject<T?, Never>(nil)
    var storeValueSubject = CurrentValueSubject<T?, Never>(nil)
    var availableValuesSubject = CurrentValueSubject<[T], Never>([])
    var unitsSubject = CurrentValueSubject<String?, Never>(nil)
    var extrasSubject = CurrentValueSubject<Any?, Never>(nil)

    init(cell: CookControlsViewCell.Type,
         title: String? = nil,
         identifier: String = "",
         enabledSubject: CurrentValueSubject<Bool, Never>? = nil,
         currentValueSubject: CurrentValueSubject<T?, Never> = CurrentValueSubject<T?, Never>(nil),
         storeValueSubject: CurrentValueSubject<T?, Never> = CurrentValueSubject<T?, Never>(nil),
         availableValuesSubject: CurrentValueSubject<[T], Never> = CurrentValueSubject<[T], Never>([]),
         unitsSubject: CurrentValueSubject<String?, Never> = CurrentValueSubject<String?, Never>(nil),
         extrasSubject: CurrentValueSubject<Any?, Never> = CurrentValueSubject<Any?, Never>(nil),
         onNavigate: ((UINavigationController, UIViewController) -> Void)? = nil,
         onClick: ((UIControl, Any?) -> Void)? = nil) {
        super.init(cell: cell, title: title, identifier: identifier, onNavigate: onNavigate, onClick: onClick)
        
        self.enabledSubject = enabledSubject
        self.currentValueSubject = currentValueSubject
        self.storeValueSubject = storeValueSubject
        self.availableValuesSubject = availableValuesSubject
        self.unitsSubject = unitsSubject
        self.extrasSubject = extrasSubject
    }
}
