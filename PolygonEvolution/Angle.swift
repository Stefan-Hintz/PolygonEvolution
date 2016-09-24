//
//  Angle.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

let π = Double.pi

struct Angle
{
	var nominator: Int
	var divider: Int

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
}
