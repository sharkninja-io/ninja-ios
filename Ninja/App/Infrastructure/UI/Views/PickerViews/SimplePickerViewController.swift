//
//  SimplePickerViewController.swift
//  Ninja
//
//  Created by Richard Jacobson on 11/22/22.
//

import UIKit

class SimplePickerViewController: UIViewController {
    
    var subview: SimplePickerView!
    var item: SimplePickerDelegate
    var callback: ((String) -> Void)!
    var dismissCallback: (() -> ())?
    
    init(_ item: SimplePickerDelegate, callback: @escaping ((String) -> Void), dismissCallback: (() -> ())? = nil) {
        self.item = item
        self.callback = callback
        self.dismissCallback = dismissCallback
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        subview = .init(frame: view.bounds)
        view = subview
        
        setupViews()
        setupPicker()
    }
    
    func setupViews() {
        subview.doneButton.onEvent() { [weak self] _ in
            guard let self else { return }
            self.callbackAndDismiss()
        }
        
        subview.bgOverlayView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(customDismiss)))
        
        let containerDrag = UISwipeGestureRecognizer(target: self, action: #selector(customDismiss))
        containerDrag.direction = .down
        subview.containerView.addGestureRecognizer(containerDrag)
    }
    
    private func setupPicker() {
        subview.pickerView.delegate = self
        subview.pickerView.dataSource = self
        subview.pickerView.selectRow(item.initialRow, inComponent: 0, animated: false)
    }
    
    // MARK: Selectors
    @objc func callbackAndDismiss() {
        callback(item.choices[subview.pickerView.selectedRow(inComponent: 0)])
        subview.customDismiss { [weak self] in
            self?.dismiss(animated: false)
        }
    }
    
    @objc func customDismiss() {
        subview.customDismiss { [weak self] in
            self?.dismiss(animated: false)
        }
    }
}

extension SimplePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return item.choices.count
    }
}

extension SimplePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return item.choices[row]
    }
}
