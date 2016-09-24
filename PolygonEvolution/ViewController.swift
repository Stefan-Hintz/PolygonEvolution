//
//  ViewController.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

let SIZE = 20.0

class ViewController: NSViewController
{
    var world = World()

    override func viewDidLoad()
	{
		super.viewDidLoad()

		updateTransformation(animate: false)
	}

	override func viewWillAppear()
	{
		if let window = view.window, let windowController = window.windowController, let document = windowController.document as? Document
		{
			document.viewController = self
			show(model: document.world)
		}
	}

	override var representedObject: Any?
	{
		didSet
		{
			if let document = representedObject as? Document
			{
				show(model: document.world)
			}
		}
	}

	func addShape()
	{
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

	func addShape(shape:Shape)
	{
		let shapeLayer = CAShapeLayer()

		shapeLayer.fillColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1).cgColor
		shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
		shapeLayer.lineWidth = 2.0
		shapeLayer.lineJoin = kCALineJoinRound

		let path = CGMutablePath()

		var first = true

		for vertex in shape.vertices
		{
			if first
			{
				first = false

				path.move(to: CGPoint(x: SIZE * vertex.x, y: SIZE * vertex.y))
			}
			else
			{
				path.addLine(to: CGPoint(x: SIZE * vertex.x, y: SIZE * vertex.y))

			}
		}

		path.closeSubpath()

		shapeLayer.path = path

		view.layer?.addSublayer(shapeLayer)
	}

	func show(model: World)
	{
		world = model

		for shape in world.shapes
		{
			addShape(shape: shape)
		}
	}

	func updateTransformation(animate: Bool)
	{
		view.layer?.sublayerTransform = CATransform3DMakeTranslation(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5, 0.0)
	}

	override func mouseDown(with event: NSEvent)
	{
		iterate()
	}

	func iterate()
	{
		survive()
		birth()
	}

	func survive()
	{

	}

	func birth()
	{

	}
}

