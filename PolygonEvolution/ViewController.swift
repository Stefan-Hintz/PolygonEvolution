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
	var simulationStarted = true
	var shapeLayer = CAShapeLayer()

	var angles = [Angle]()
	var sum = 0

	override func viewDidLoad()
	{
		super.viewDidLoad()

		updateTransformation(animate: false)

		addShape()

		for _ in 0 ..< 5
		{
			let angle = Angle()

			angle.divider = 20

			angles.append(angle)
		}

		sum = (5 - 2) * 20
	}

	override func viewWillAppear()
	{
		if let window = view.window, let windowController = window.windowController, let document = windowController.document as? Document
		{
			document.viewController = self
			show(model: document.world)
		}

		view.window?.acceptsMouseMovedEvents = true
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
		shapeLayer.fillColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1).cgColor
		shapeLayer.strokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
		shapeLayer.lineWidth = 2.0
		shapeLayer.lineJoin = kCALineJoinRound

		let path = CGMutablePath()

		path.move(to: CGPoint(x: 0, y: 0))
		path.addLine(to: CGPoint(x: SIZE, y: 0))
		path.addLine(to: CGPoint(x: SIZE, y: SIZE))
		path.addLine(to: CGPoint(x: 0, y: SIZE))
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

		//		path.closeSubpath()

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
		view.layer?.sublayerTransform = CATransform3DScale(CATransform3DMakeTranslation(view.bounds.size.width * 0.5, view.bounds.size.height * 0.5, 0.0)
, 10.0, 10.0, 1.0)
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

	override func keyDown(with event: NSEvent)
	{
		if let value = event.characters?.unicodeScalars.first?.value
		{
			switch Int(value)
			{
			// Space
			case 32:
				toggleSimulation()

			case NSRightArrowFunctionKey:
				simulate()

			default:
				super.keyDown(with: event)
			}
		}
	}

	func toggleSimulation()
	{
		simulationStarted = !simulationStarted
	}

	override func mouseMoved(with event: NSEvent)
	{
		if simulationStarted
		{
			simulate()
		}
	}

	func simulate()
	{
		while true
		{
			let path = CGMutablePath()

			var x = 0.0
			var y = 0.0

			path.move(to: CGPoint(x: x, y: y))

			var sumAngle = 0.0
			var s = 0

			for angle in angles
			{
				let a = angle.radians()
				let b = π - a

				path.addLine(to: CGPoint(x: x, y: y))

				x += SIZE * cos(sumAngle)
				y += SIZE * sin(sumAngle)

				sumAngle += b
				s += 20 - angle.nominator
			}

			for angle in angles
			{
				angle.nominator += 1

				if 2 * angle.nominator < angle.divider
				{
					break
				}

				angle.nominator = 1
			}

//			if s != sum
//			{
//				print("sum: \(s) \(sum)")
//
//				continue
//			}

			if x * x + y * y > ε
			{
//				print("\(x) \(y)")

				continue
			}

			print("sum: \(s) \(sum)")


			path.closeSubpath()

			shapeLayer.path = path
			
			break
		}
	}
}

