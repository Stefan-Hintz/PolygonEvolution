//
//  ViewController.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

class ViewController: NSViewController
{
	override func viewDidLoad()
	{
		super.viewDidLoad()

		updateTransformation(animate: false)

		let shapeLayer = CAShapeLayer()

		shapeLayer.fillColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
		shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
		shapeLayer.lineWidth = 2.0
		shapeLayer.lineJoin = kCALineJoinRound

		let path = CGMutablePath()

		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: 20, y: 0))
		path.addLine(to: CGPoint(x: 20, y: 20))
		path.addLine(to: CGPoint(x: 0, y: 20))
		path.closeSubpath()

		shapeLayer.path = path

		view.layer?.addSublayer(shapeLayer)
	}

	override var representedObject: Any?
	{
		didSet
		{
			// Update the view, if already loaded.
		}
	}

	func updateTransformation(animate: Bool)
	{
		view.layer?.sublayerTransform = CATransform3DMakeTranslation(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5, 0.0)
	}
}

