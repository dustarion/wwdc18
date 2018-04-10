/**
 *  Planet.swift
 *  Description :
 *  This file contains functions for use with JourneyViewController()
 *  Allows fast creation of a Planet
 *  Planets enum contains the data shown in JourneyViewController()
 *
 */

import SceneKit

// MARK:- CreatePlanet
public func createPlanet(withTexture: String, rotate: Bool = true, duration: Double = 30) -> SCNNode {
    let planet = SCNNode()
    
    // Map the designated texture onto the sphere
    planet.geometry = SCNSphere(radius: 1)
    planet.geometry?.firstMaterial?.diffuse.contents = UIImage(named: withTexture)
    planet.geometry?.firstMaterial?.shininess = 50
    
    if rotate {
    // Make the planet rotate
    let action = SCNAction.rotate(by: 360 * CGFloat(Double.pi / 180), around: SCNVector3(x:0, y:1, z:0), duration: duration)
    let repeatAction = SCNAction.repeatForever(action)
    planet.runAction(repeatAction)
    }
    
    return planet
}

// MARK:- AddRingsToSaturn
public func addRingsToSaturn(node:SCNNode) {
    // Create the Ring
    let ring = SCNNode(geometry: SCNTube(innerRadius: 1.5, outerRadius: 2.0, height: 0.01))
    ring.name = "ring"
    ring.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "saturnRingTexture.png")
    ring.rotation = SCNVector4Make(0.7, 0, 0, 0.5)
    // Float(0.471238898) if we want to be really accurate
    node.addChildNode(ring)
}

// MARK:- Planets
public enum Planets {
    case jupiter
    case saturn
    case titan
    
    // Contains the image textures that are used
    public var texture: String {
        switch self {
        case .jupiter:
            return "jupiter.jpg"
        case .saturn:
            return "saturn.jpg"
        case .titan:
            return "titan.jpg"
        }
    }
    
    public var title: String {
        switch self {
        case .jupiter:
            return "Jupiter Flyby"
        case .saturn:
            return "Saturn Flyby"
        case .titan:
            return "Titan Flyby"
        }
    }
    
    public var description: String {
        switch self {
        case .jupiter:
            return "Because of the greater photographic resolution allowed by a closer approach, most observations of the moons, rings, magnetic fields, and the radiation belt environment of the Jovian system were made during the 48-hour period that bracketed the closest approach. Voyager 1 made a number of important discoveries about Jupiter, its satellites, its radiation belts, and its never-before-seen planetary rings."
        case .saturn:
            return "The space probe's cameras detected complex structures in the rings of Saturn, and its remote sensing instruments studied the atmospheres of Saturn and its giant moon Titan. The Voyagers found aurora-like ultraviolet emissions of hydrogen at mid-latitudes in the atmosphere, and auroras at polar latitudes (above 65 degrees)."
        case .titan:
            return "Voyager was able to determine the atmosphere's composition, density, and pressure. Titan's mass was also measured by observing its effect on the probe's trajectory. Thick haze prevented any visual observation of the surface, but the measurement of the atmosphere's composition, temperature, and pressure led to speculation that lakes of liquid hydrocarbons could exist on the surface."
        }
    }
}
