//
//  DetailViewController.swift
//  Scales
//
//  Created by Jenny Swift on 17/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit
import SwiftEntryKit

protocol DetailViewControllerDelegate: class {
    func didUpdateFood(_ detailItem: Food, _ newAmount: Int)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailHeader: UINavigationItem!
    @IBOutlet weak var detailAmountLabel: UILabel!
    @IBOutlet weak var additionTextField: UITextField!
    @IBOutlet weak var subtractionTextField: UITextField!
    
    @IBAction func reset(_ sender: Any) {
        detailItem?.amount = 0
        guard let food = detailItem else {return}
        updateAmountInMasterView(food)
    }
    
    @IBAction func copyToClipboard(_ sender: Any) {
        if let detail = detailItem {
            UIPasteboard.general.string = String(detail.amount)
            showNote()
        }
    }
    weak var delegate: DetailViewControllerDelegate?
    
    var action = Action.addition
    
    enum Action {
        case addition
        case subtraction
    }
    
    func getNoteAttributes() -> EKAttributes {
        var attributes = EKAttributes.topNote
        
        attributes.entryBackground = .color(color: .darkGray)
        attributes.displayDuration = 10
        
        return attributes
    }
    
    func showNote() -> Void {
        let text = "Copied Successfully"
        let style = EKProperty.LabelStyle(font: UIFont.systemFont(ofSize: 14), color: .white, alignment: .center)
        let labelContent = EKProperty.LabelContent(text: text, style: style)
        
        let contentView = EKNoteMessageView(with: labelContent)
        
        SwiftEntryKit.display(entry: contentView, using: getNoteAttributes())
    }
    
    @IBAction func subtractionInputFocused(_ sender: Any) {
        print("subtraction focused")
    }
    
    @IBAction func additionInputFocused(_ sender: Any) {
        print("addition focused")
    }
    
    fileprivate func updateAmountInMasterView(_ food: Food) {
        if let newAmount = detailItem?.amount {
            delegate?.didUpdateFood(food, newAmount)
        }
    }
    
    func addFromInputField() -> Void {
        switch action {
        case Action.addition:
            if let value = additionTextField.text {
                if let valueAsInt = Int(value) {
                    detailItem?.amount += valueAsInt
                    guard let food = detailItem else {return}
                    updateAmountInMasterView(food)
                    additionTextField.text = ""
                }
                
            }
        case Action.subtraction:
            if let value = subtractionTextField.text {
                if let valueAsInt = Int(value) {
                    detailItem?.amount -= valueAsInt
                    guard let food = detailItem else {return}
                    updateAmountInMasterView(food)
                    subtractionTextField.text = ""
                }
                
            }
        }
        
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailHeader.title = detail.name
            updateAmountText()
        }
    }
    
    func updateAmountText() {
        if let detail = detailItem, let detailAmountLabel = detailAmountLabel {
            detailAmountLabel.text = String(detail.amount)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DetailViewController.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        
        //For hiding keyboard when user taps outside
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        additionTextField.resignFirstResponder()
        subtractionTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        addFromInputField()
    }

    var detailItem: Food? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }


}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == additionTextField {
            action = Action.addition
        }
        if textField == subtractionTextField {
            action = Action.subtraction
        }
        return true
    }
}

