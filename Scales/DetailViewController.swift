//
//  DetailViewController.swift
//  Scales
//
//  Created by Jenny Swift on 17/12/18.
//  Copyright © 2018 Jenny Swift. All rights reserved.
//

import UIKit

protocol DetailViewControllerDelegate: class {
    func didUpdateFood(_ detailItem: Food)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var detailHeader: UINavigationItem!
    @IBOutlet weak var detailAmountLabel: UILabel!
    
    weak var delegate: DetailViewControllerDelegate?
    
//    var objects: [Food] = []
    
    @IBAction func add(_ sender: Any) {
        detailItem?.amount += 1
        guard let food = detailItem else {return}
        delegate?.didUpdateFood(food)
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
    }

    var detailItem: Food? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

