//
//  AccountService.swift
//  Ninja
//
//  Created by Martin Burch on 8/29/22.
//

import Foundation

protocol AccountService {
    
    // TODO: // FDM4 vs Intershop
    func register()
    func confirm()
    func retrieve()
    func update()
    func delete()
    
}
