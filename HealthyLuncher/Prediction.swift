//
//  Prediction.swift
//  HealthyLuncher
//
//  Created by Anna on 19/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

/// Types of a prediction result.
enum Prediction {
    
    /// Healthy lunch.
    case healthy
    
    /// Fast food lunch.
    case fastFood
    
    /// Classification has failed with an error.
    case failed(Error?)
    
    /// Prediction result is empty.
    case empty
    
    /// Initializes the prediction enum with result returned from a ML model.
    ///
    /// - Parameter classLabel: The identifier returned by a model.
   init?(classLabel: String) {
        if classLabel == "fast food" {
            self = .fastFood
        } else if classLabel == "healthy" {
            self = .healthy
        } else {
            return nil
        }
    }
    
    /// The description of a prediction used for showing the information to the user.
    var description: String {
        switch self {
        case .healthy:
            return "HEALTHY 💪🏻"
        case .fastFood:
            return "FAST FOOD 😣"
        case .failed(let error):
            let text = "Unable to classify image 😔"
            guard let error = error else { return text }
            return text + ":\n" + error.localizedDescription
        case .empty:
            return "Nothing was recognized 😯"
        }
    }
}
