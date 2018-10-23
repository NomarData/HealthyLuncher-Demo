//
//  ImageClassificationService.swift
//  HealthyLuncher
//
//  Created by Anna on 23/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

import UIKit
import CoreML
import Vision

final class ImageClassificationService {
    
    var completionHandler: ((Prediction) -> ())?
    
    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: ImageClassifier().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.handleClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Image Classifier ML model: \(error)")
        }
    }()
    
    func predict(for image: UIImage) {
        let orientation = CGImagePropertyOrientation(image.imageOrientation)
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func handleClassifications(for request: VNRequest, error: Error?) {
        guard let results = request.results else {
            self.completionHandler?(Prediction.failed(error))
            return
        }
        guard let classifications = results as? [VNClassificationObservation],
            let bestClassification = classifications.first,
            let prediction = Prediction(classLabel: bestClassification.identifier) else {
                self.completionHandler?(Prediction.empty)
                return
        }
        self.completionHandler?(prediction)
    }
}
