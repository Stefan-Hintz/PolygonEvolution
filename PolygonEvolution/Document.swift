//
//  Document.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

class Document: NSDocument
{
	weak var windowController: NSWindowController!
	weak var viewController: ViewController!

    var world = World()
    
	override class func autosavesInPlace() -> Bool
	{
		return true
	}

	override func makeWindowControllers()
	{
		// Returns the Storyboard that contains your Document window.
		let storyboard = NSStoryboard(name: "Main", bundle: nil)
		windowController = storyboard.instantiateController(withIdentifier: "Document Window Controller") as! NSWindowController
		self.addWindowController(windowController)
	}

	override func data(ofType typeName: String) throws -> Data
	{
		let json = world.toJSON()

		return try JSONSerialization.data(withJSONObject: json, options: [])
	}

	override func read(from data: Data, ofType typeName: String) throws
	{
		if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
		{
			world.fromJSON(object: jsonObject)

			if let viewController = self.viewController
			{
				viewController.representedObject = self
			}

            return
		}

		throw NSError(domain: "PolygonEvolution", code: 2, userInfo: nil)
	}
}

