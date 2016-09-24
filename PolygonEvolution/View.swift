//
//  View.swift
//  Girih
//
//  Created by Stefan Hintz on 01.04.2015.

import Cocoa

class View: NSView
{
	override var acceptsFirstResponder: Bool { get {return true} }

	override func setFrameSize(_ newSize: NSSize)
	{
		super.setFrameSize(newSize)

		if let windowController = window?.windowController,
			let viewController = windowController.contentViewController as? ViewController
		{
			viewController.updateTransformation(animate: false)
		}
	}
}
