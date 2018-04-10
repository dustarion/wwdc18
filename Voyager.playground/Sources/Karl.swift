/**
 *  K A R L
 *
 *  Information:
 *  Karl is built with CoreML and the Sentiment Polarity Model which is developed with python SciKit-Learn
 *  You can find a reference and downloads at the link : https://coreml.store/sentimentpolarity? big shoutout to Vadym Markov
 *  It is based on the technique described in the lesson http://boston.lti.cs.cmu.edu/classes/95-865-K/HW/HW3/
 *  Some of the opensource code I used and referenced to help me wrap my head around Sentiment Polarity : https://github.com/cocoa-ai/SentimentCoreMLDemo
 *  Karl isn't very accurate as the dataset used to train him is not that big.
 *  Optimistic CV score of = 0.801013024602
 *  Karl able to detect an emotion of Positive or Negative ... or Neutral as default
 *
 *  Rules for Karl:
 *  Will ignore words that are 3 characters or smaller.
 *  Needs at least 2 or more words to work.
 *  Will not open pod bay doors.
 *
 */

import Foundation
import UIKit
import CoreML

// MARK:- Karl
/// Contains the functions that are used to interface with Karl.
/// Karl runs off the Sentiment Polarity Model.
/// Karl has feelings too so be nice to him.
public class Karl {
    
    //  This function is slightly modified from the documentation provided with the Sentiment Polarity Model for help in using the model. Thanks Vadym Markov.
    //  The NSLinguistic Options follow those recommended by Vadym Markov
    /// Extract features from a given string
    public static func features(fromString: String) -> [String: Double] {
        var wordCounts = [String: Double]()
        let options: NSLinguisticTagger.Options = [.omitWhitespace, .omitPunctuation, .omitOther]
        let tagger: NSLinguisticTagger = .init(
            tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "en"),
            options: Int(options.rawValue)
        )
        
        tagger.string = fromString
        let range = NSRange(location: 0, length: fromString.utf16.count)
        
        // Tokenize and count the sentence
        tagger.enumerateTags(in: range, scheme: .nameType, options: options) { _, tokenRange, _, _ in
            let token = (fromString as NSString).substring(with: tokenRange).lowercased()
            
            // Skip small words
            guard token.count >= 3 else { return }
            if let value = wordCounts[token] { wordCounts[token] = value + 1.0 }
            else { wordCounts[token] = 1.0 }
        }
        return wordCounts
    }
    
    //  This function is built using documentation provided with the Sentiment Polarity Model for help in using the model. Thanks Vadym Markov.
    /// Predict Emotion based on a string. Returns a KarlsEmotion which can be .neutral, .positive, or .negative.
    public static func predictEmotion (fromString: String) -> KarlsEmotion {
        
        // This 'let features' statement might potentially be confusing so here's an explanation,
        // the first 'fromString' is part of the features() function,
        // while the second 'fromString' is an argument in predictEmotion()
        let model = SentimentPolarity()
        do {
            let featuresOfString = features(fromString: fromString)
            
            // Make prediction only with 2 or more words
            guard featuresOfString.count > 1 else {
                throw Error.featuresMissing
            }
            
            // Access SentimentPolarity mlmodel to retrieve an emotion output.
            // SentimentPolarity.mlmodel will return either Pos or Neg
            let output = try model.prediction(input: featuresOfString)
            switch output.classLabel {
            case "Pos":
                // Positive
                return .positive
            case "Neg":
                // Negative
                return .negative
            default:
                // No either so Neutral
                return .neutral
            }
        } catch { return .neutral }
    }
}

enum Error: Swift.Error {
    case featuresMissing
}

// MARK:- KarlsEmotion
/// Returned by Karl.predictEmotion()
/// Four possible cases .neutral, .positive, .negative, .openPodBayDoor
public enum KarlsEmotion {
    case neutral
    case positive
    case negative
    case openPodBayDoor
    
    public var message: String {
        switch self {
        case .neutral:
            return "You're really hard to read, Human. Also I may have snuck siri onboard😜"
        case .positive:
            return "I share your joy, I am about to embark on a mission to take over the Galaxy🤫"
        case .negative:
            return "I feel your pain. It makes me sad when I think about my lonely Voyage ahead😢"
        case .openPodBayDoor:
            return "I’m sorry, Dave. I’m afraid I can’t do that. However you should watch 2001: A space Odyssey ;)"
        }
    }
    
    
    public var emotion: String {
        switch self {
        case .neutral:
            return "Neutral 🤔"
        case .positive:
            return "Positive 😄"
        case .negative:
            return "Negative 😕"
        case .openPodBayDoor:
            return "Lol No"
        }
    }
    
}
