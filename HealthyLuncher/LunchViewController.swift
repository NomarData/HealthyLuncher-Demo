//
//  LunchViewController.swift
//  HealthyLuncher
//
//  Created by Anna on 19/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

import UIKit

class LunchViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var photoBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var predictionView: UIView!
    
    private let classificationService = ImageClassificationService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        classificationService.completionHandler = { [weak self] prediction in
            DispatchQueue.main.async {
                self?.updatePredictionLabel(with: prediction)
            }
        }
    }
    
    @IBAction func openPhoto(_ sender: Any) {
        present(imagePickerController, animated: true)
    }
    
    func updatePredictionLabel(with prediction: Prediction) {
        predictionLabel.text = prediction.description
        switch prediction {
        case .healthy:
            predictionLabel.textColor = #colorLiteral(red: 0.3371219039, green: 0.7178928256, blue: 0.09001944214, alpha: 1)
        case .fastFood:
            predictionLabel.textColor = #colorLiteral(red: 0.9815813899, green: 0.01640440524, blue: 0.2419521809, alpha: 1)
        case .failed(_), .empty:
            predictionLabel.textColor = .darkGray
        }
    }
}

extension LunchViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imageView.image = image
        predictionLabel.text = "Classifying..."
        predictionLabel.textColor = .darkGray
        classificationService.predict(for: image)
    }
}

