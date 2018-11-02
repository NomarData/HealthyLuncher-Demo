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
        checkLunch()
    }
    
    private func checkLunch() {
        predictLabel.textColor = .lightGray
        guard let text = lunchTextField.text, !text.isEmpty else {
            predictLabel.text = "Text can not be empty 🤨"
            return
        }
        predict(for: text)
    }
    
    private func predict(for text: String) {
        do {
            let model = try NLModel(mlModel: LunchTextClassifier().model)
            guard let classLabel = model.predictedLabel(for: text),
                let prediction = Prediction(classLabel: classLabel) else {
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
            fatalError("Failed to load Text Classifier ML model: \(error)")
        }
    }
}

extension TextViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        lunchTextField.resignFirstResponder()
        checkLunch()
        return true
    }
}
