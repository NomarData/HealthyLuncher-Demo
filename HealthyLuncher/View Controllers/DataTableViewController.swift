//
//  DataTableViewController.swift
//  HealthyLuncher
//
//  Created by Anna on 24/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

import Foundation
import UIKit

class DataTableViewController: UIViewController {
    
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var producentTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBAction func checkDataTable(_ sender: Any) {
        predictLabel.textColor = .lightGray
        guard let name = nameTextField.text, !name.isEmpty,
            let producent = producentTextField.text, !producent.isEmpty,
            let priceText = priceTextField.text, !priceText.isEmpty,
            let price = Double(priceText) else {
                predictLabel.text = "Data can not be empty 🤨"
                return
        }
        let model = LunchDataTableClassifier()
        do {
            let output = try model.prediction(company: producent, name: name, price: price)
            guard let prediction = Prediction(classLabel: output.type) else {
                    predictLabel.text = Prediction.empty.description
                    return
            }
            predictLabel.text = prediction.description
            switch prediction {
            case .healthy:
                predictLabel.textColor = #colorLiteral(red: 0.3371219039, green: 0.7178928256, blue: 0.09001944214, alpha: 1)
            case .fastFood:
                predictLabel.textColor = #colorLiteral(red: 0.9815813899, green: 0.01640440524, blue: 0.2419521809, alpha: 1)
            default:
                predictLabel.textColor = .lightGray
            }
        } catch {
            predictLabel.text = Prediction.failed(error).description
        }
    } 
}
