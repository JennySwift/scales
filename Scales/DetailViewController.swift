//
//  DetailViewController.swift
//  Scales
//
//  Created by Jenny Swift on 17/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func didUpdateFood(_ detailItem: Food, _ byAmount: Int)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailHeader: UINavigationItem!
    @IBOutlet weak var detailAmountLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: DetailViewControllerDelegate?
    
//    var objects: [Food] = []
    
    @IBAction func add(_ sender: Any) {
        detailItem?.amount += 1
        guard let food = detailItem else {return}
        delegate?.didUpdateFood(food, 1)
    }
    
    func addFromInputField() -> Void {
        if let value = textField.text {
            print(value)
            if let valueAsInt = Int(value) {
                detailItem?.amount += valueAsInt
                guard let food = detailItem else {return}
                delegate?.didUpdateFood(food, valueAsInt)
                textField.text = ""
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
}

