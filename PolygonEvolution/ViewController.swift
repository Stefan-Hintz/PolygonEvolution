//
//  ViewController.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

class ViewController: NSViewController
{
	var world = World(jsonString: [:])

	override func viewDidLoad()
	{
		super.viewDidLoad()

		updateTransformation(animate: false)

		let shapeLayer = CAShapeLayer()

		shapeLayer.fillColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
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
			if let window = view.window, let windowController = window.windowController, let document = windowController.document as? Document
			{
				document.viewController = self

				if let world = document.world
				{
					// Update the view, if already loaded.
					show(model: world)
				}
			}
		}
	}

	func show(model: World)
	{
		world = model



	}

	func updateTransformation(animate: Bool)
	{
		view.layer?.sublayerTransform = CATransform3DMakeTranslation(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5, 0.0)
	}
}

