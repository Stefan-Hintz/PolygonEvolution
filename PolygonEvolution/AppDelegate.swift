//
//  AppDelegate.swift
//  PolygonEvolution
//
//  Created by Stefan Hintz on 24.09.2016.

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate
{
	@IBOutlet weak var examplesMenu: NSMenu!

	func applicationDidFinishLaunching(_ notification: Notification)
	{
		updateExamplesMenu()
	}

	func updateExamplesMenu()
	{
		let pathnames = Bundle.main.paths(forResourcesOfType: "gons", inDirectory: "Examples")
		for pathname in pathnames
		{
			let menuItem = NSMenuItem(title: name(pathname: pathname), action: #selector(openExample(_:)), keyEquivalent: "")
			menuItem.representedObject = pathname

			examplesMenu.addItem(menuItem)
		}
	}

	func name(pathname: String) -> String
	{
		let string = pathname.components(separatedBy: "/").last!.replacingOccurrences(of: ".gons", with: "")

		var upperCase = true
		var result = ""

		for character in string.characters
		{
			let letter = String(character)
			let upper = letter.uppercased() == letter

			if !upperCase && upper
			{
				result.append(" ")
			}

			result.append(character)

			upperCase = upper
		}

		return result
	}

	@IBAction func openExample(_ sender: AnyObject?)
	{
		if let menuItem = sender as? NSMenuItem
		{
			if let pathname = menuItem.representedObject as? String
			{
				do
				{
					let document = try NSDocumentController.shared().openUntitledDocumentAndDisplay(true)

					document.displayName = menuItem.title
					(document as? Document)?.windowController.window?.title = menuItem.title

					try document.read(from: URL(fileURLWithPath: pathname), ofType: "gons")

					document.updateChangeCount(.changeReadOtherContents)
				}
				catch
				{
				}
			}
		}
	}
}

