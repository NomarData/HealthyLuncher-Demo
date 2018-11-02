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
    
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var producentTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [nameTextField, producentTextField, priceTextField].forEach({
            $0?.delegate = self
        })
    }
    
    
    @IBAction func checkLunchDataTable(_ sender: Any) {
       predictLunch()
    }
    
    private func predictLunch() {
        predictionLabel.textColor = .lightGray
        guard let name = nameTextField.text, !name.isEmpty,
            let producent = producentTextField.text, !producent.isEmpty,
            let priceText = priceTextField.text, !priceText.isEmpty else {
                predictionLabel.text = "Data can not be empty 🤨"
                return
        }
        guard let price = Double(priceText) else {
            predictionLabel.text = "Price should include only numbers 🤨"
            return
        }
        let model = LunchDataTableClassifier()
        do {
            let output = try model.prediction(company: producent, name: name, price: price)
            guard let prediction = Prediction(classLabel: output.type) else {
                predictionLabel.text = Prediction.empty.description
                return
            }
            predictionLabel.text = prediction.description
            predictionLabel.textColor = prediction.color
        } catch {
            predictionLabel.text = Prediction.failed(error).description
        }
    }
}

extension DataTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            producentTextField.becomeFirstResponder()
        }
        if textField == producentTextField {
            priceTextField.becomeFirstResponder()
        }
        if textField == priceTextField {
            priceTextField.resignFirstResponder()
            predictLunch()
        }
        return true
    }
}
