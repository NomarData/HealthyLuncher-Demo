//
//  TextViewController.swift
//  HealthyLuncher
//
//  Created by Anna on 24/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

import UIKit
import NaturalLanguage

class TextViewController: UIViewController {
    
    @IBOutlet weak var predictLabel: UILabel!
    @IBOutlet weak var lunchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lunchTextField.delegate = self
    }
    
    @IBAction func checkLunchText(_ sender: Any) {
        predictLunch()
    }
    
    private func predictLunch() {
        predictLabel.textColor = .lightGray
        guard let text = lunchTextField.text, !text.isEmpty else {
            predictLabel.text = "Text can not be empty 🤨"
            return
        }
        do {
            let model = try NLModel(mlModel: LunchTextClassifier().model)
            guard let classLabel = model.predictedLabel(for: text),
                let prediction = Prediction(classLabel: classLabel) else {
                    predictLabel.text = Prediction.empty.description
                    return
            }
            predictLabel.text = prediction.description
            predictLabel.textColor = prediction.color
        } catch {
            fatalError("Failed to load Text Classifier ML model: \(error)")
        }
    }
}

extension TextViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lunchTextField.resignFirstResponder()
        predictLunch()
        return true
    }
}
