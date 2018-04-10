/**
 *  GlobalFunctions.swift
 *  Description :
 *  This file contains any general functions we wish to reuse throughout the project.
 *
 */

import Foundation
import UIKit
import AVFoundation

// MARK: -
/// Obtain a uiColor from a Hex value.
/// You might need to add a '0x' to the beginning of your Hex value.
/// Pass in a value of type UInt32
public func uicolorFromHex(rgbValue:UInt32)->UIColor{
    let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
    let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
    let blue = CGFloat(rgbValue & 0xFF)/256.0
    
    return UIColor(red:red, green:green, blue:blue, alpha:1.0)
}

// MARK: -
/// Helps with some time based animations. Code will execute after said delay.
public func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

// MARK: -
/// Returns the current distance of the voyager 1 probe from our sun
public func voyagerDistanceFromSun() -> Int {
    //  As of June 10, 2015, 10:17 UTC the distance between Voyager 1 and Earth was 130.81103152 AU.
    //  When added one AU (approximate distance between Earth and Sun) to it,
    //  the approximate distance between Voyager 1 and the Sun, is 131.64053152 Au or 19693143213.2082km
    //  This would be 455624220 Seconds between referenced date of Jan 1 2001 and our distance reference date
    
    // Date is a 64-bit floating point number measuring the number of seconds
    // since the reference date of January 1, 2001 at 00:00:00 UTC
    let currentDateTime = Date()
    let secondsSinceReference = currentDateTime.timeIntervalSinceReferenceDate
    
    // Calculate how far voyager has travelled in this time in kilometers.
    // Voyager 1 travels at around 17km/s. Exact number would be closer to 16.9994872608km/s
    let voyagerDistance = (( secondsSinceReference - 455624220 ) * 17 ) + 19693143213.2082
    
    // Round of this distance to 3.d.p
    // We plan to return the number without any decimal places however this is here in case greater accuracy is needed.
    // Using the method recommended in : https://docs.oracle.com/cd/E19957-01/806-3568/ncg_goldberg.html
    // voyagerDistance = Double(round(1000*voyagerDistance)/1000)
    
    // Round off to a whole number
    let roundedVoyagerDistance = Int(round(voyagerDistance))
    
    return roundedVoyagerDistance
}

// MARK: -
/// Play Background Music
public var player: AVAudioPlayer?
public func playSound() {
    guard let url = Bundle.main.url(forResource: "VoyagerBGMusic", withExtension: "mp3") else { return }
    
    do {
        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        try AVAudioSession.sharedInstance().setActive(true)
        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
        guard let player = player else { return }
        player.play()
    } catch let error { print(error.localizedDescription) }
}

// MARK: - UIView Fade Animations
public extension UIView {
    /// Fade in the specified UIView
    public func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    /// Fade out the specified UIView
    public func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}

// MARK: - UITableView Scroll Animations
public extension UITableView {
    public func scrollToBottom(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: IndexPath(row: row - 1, section: section - 1), at: .bottom, animated: animated)
            }
        }
    }
}
