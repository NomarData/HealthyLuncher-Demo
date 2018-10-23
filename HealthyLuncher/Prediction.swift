//
//  Prediction.swift
//  HealthyLuncher
//
//  Created by Anna on 19/10/2018.
//  Copyright © 2018 Netguru. All rights reserved.
//

enum Prediction {
    case healthy
    case fastFood
    case failed(Error?)
    case empty
    
   init?(classLabel: String) {
        if classLabel == "fast food" {
            self = .fastFood
        } else if classLabel == "healthy" {
            self = .healthy
        } else {
            return nil
        }
    }
    
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
