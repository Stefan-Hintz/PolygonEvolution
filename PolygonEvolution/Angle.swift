//
//  Angle.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

let π = Double.pi

class Angle
{
	var nominator = 0
	var divider = 0
    var radian = 0.0
    
    func value() -> Double
	{
		return Double(nominator) / Double(divider)
	}

	func degrees() -> Double
	{
		return value() * 360
	}

	func radians() -> Double
	{
		return value() * 2.0 * π
	}
    
    func setRadian(r: Double) {
        radian = r
    }
}
