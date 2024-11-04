//
//  UIControl+Extensions.swift
//  Ninja
//
//  Created by Martin Burch on 9/1/22.
//

import UIKit

extension UIControl {
    
    func onEvent(for event: UIControl.Event = .primaryActionTriggered, closure: @escaping (UIControl) -> ()) {
        self.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            closure(self)
        }), for: event)
    }
    
    func removeEvent(for event: UIControl.Event = .primaryActionTriggered) {
        self.enumerateEventHandlers { action, target, regEvent, stop in
            if let action = action, event == regEvent {
                self.removeAction(action, for: event)
            }
        }
    }
    
}
