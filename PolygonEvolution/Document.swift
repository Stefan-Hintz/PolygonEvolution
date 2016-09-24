//
//  Document.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

class Document: NSDocument
{
	weak var windowController: NSWindowController!

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
		let string = ""

		if let value = string.data(using: String.Encoding.utf8)
		{
			return value
		}

		throw NSError(domain: "PolygonEvolution", code: 1, userInfo: nil)
	}

	override func read(from data: Data, ofType typeName: String) throws
	{
		if let string = String(data: data, encoding: String.Encoding.utf8)
		{

			return
		}

		throw NSError(domain: "PolygonEvolution", code: 2, userInfo: nil)
	}
}

