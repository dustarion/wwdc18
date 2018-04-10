/**
 *  SentimentPolarity.swift
 *  Description :
 *  This file contains code generated in another xcode project in order to easily integrate SentimentPolarity.mlmodelc
 *
 */

import CoreML

/// Model Prediction Input Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarityInput : MLFeatureProvider {

    /// Features extracted from the text. as dictionary of strings to doubles
    public var input: [String : Double]
    
    public var featureNames: Set<String> {
        get {
            return ["input"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "input") {
            return try! MLFeatureValue(dictionary: input as [NSObject : NSNumber])
        }
        return nil
    }
    
  public   init(input: [String : Double]) {
        self.input = input
    }
}


/// Model Prediction Output Type
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarityOutput : MLFeatureProvider {

    /// The most likely polarity (positive or negative), for the given input. as string value
    public let classLabel: String

    /// The probabilities for each class label, for the given input. as dictionary of strings to doubles
    public let classProbability: [String : Double]
    
    public var featureNames: Set<String> {
        get {
            return ["classLabel", "classProbability"]
        }
    }
    
    public func featureValue(for featureName: String) -> MLFeatureValue? {
        if (featureName == "classLabel") {
            return MLFeatureValue(string: classLabel)
        }
        if (featureName == "classProbability") {
            return try! MLFeatureValue(dictionary: classProbability as [NSObject : NSNumber])
        }
        return nil
    }
    
    public init(classLabel: String, classProbability: [String : Double]) {
        self.classLabel = classLabel
        self.classProbability = classProbability
    }
}


/// Class for model loading and prediction
@available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *)
public class SentimentPolarity {
    public var model: MLModel

    /**
        Construct a model with explicit path to mlmodel file
        - parameters:
           - url: the file url of the model
           - throws: an NSError object that describes the problem
    */
    public init(contentsOf url: URL) throws {
        self.model = try MLModel(contentsOf: url)
    }

    /// Construct a model that automatically loads the model from the app's bundle
    public convenience init() {
        let bundle = Bundle(for: SentimentPolarity.self)
        let assetPath = bundle.url(forResource: "SentimentPolarity", withExtension:"mlmodelc")
        try! self.init(contentsOf: assetPath!)
    }

    /**
        Make a prediction using the structured interface
        - parameters:
           - input: the input to the prediction as SentimentPolarityInput
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SentimentPolarityOutput
    */
    public func prediction(input: SentimentPolarityInput) throws -> SentimentPolarityOutput {
        let outFeatures = try model.prediction(from: input)
        let result = SentimentPolarityOutput(classLabel: outFeatures.featureValue(for: "classLabel")!.stringValue, classProbability: outFeatures.featureValue(for: "classProbability")!.dictionaryValue as! [String : Double])
        return result
    }

    /**
        Make a prediction using the convenience interface
        - parameters:
            - input: Features extracted from the text. as dictionary of strings to doubles
        - throws: an NSError object that describes the problem
        - returns: the result of the prediction as SentimentPolarityOutput
    */
    public func prediction(input: [String : Double]) throws -> SentimentPolarityOutput {
        let input_ = SentimentPolarityInput(input: input)
        return try self.prediction(input: input_)
    }
}
