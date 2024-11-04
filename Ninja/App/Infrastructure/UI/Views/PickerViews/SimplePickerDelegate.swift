//
//  PickerDelegate.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/3/22.
//

import UIKit

protocol SimplePickerDelegate {
    var modalTitle: String { get }
    var choices: [String] { get }
    var initialRow: Int { get }
}
