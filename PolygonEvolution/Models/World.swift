//
//  World.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation

typealias Scalar = Double

class Vector2: Hashable
{
    var x = 0.0
    var y = 0.0
    
    func setVector(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
    
    func add(v: Vector2)
    {
        x = x + v.x
        y = y + v.y
    }
    
    func sub(v: Vector2)
    {
        x = x - v.x
        y = y - v.y
    }
    
    func scale(s: Double)
    {
        x = x*s
        y = y*s
    }
    
    func fromJSON(object: [String: Any])
    {
        if let x = object["x"] as? Scalar
        {
            self.x = x
        }

        if let y = object["y"] as? Scalar
        {
            self.y = y
        }
    }
    
    func toJSON() -> [String: Any]
    {
        var object = [String: Any]()

        object["x"] = x
        object["y"] = y
        
        return object
    }
    
    // make class Hashable
    var hashValue: Int
        {
        get {
            return (self.x + self.y).hashValue
        }
    }
    
    // make class Equatable
    public static func ==(lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

class Edge: Hashable
{
    var shape = Shape()
    var start = Vector2()
    var end = Vector2()

    var worldStart = Vector2()
    var worldEnd = Vector2()
    
    
    func setWorldCoords(center: Vector2)
    {
    
            worldStart.scale(s: SIZE)
            worldStart.add(v: center)
            worldStart.sub(v: shape.center)
    
            worldEnd.scale(s: SIZE)
            worldEnd.add(v: center)
            worldEnd.sub(v: shape.center)
    }
    
    func setEdge(start: Vector2, end: Vector2, shape: Shape)
    {
        
        self.shape = shape
        self.start = start
        self.end = end
    }
    
    func fromJSON(object: [String: Any])
    {
        start.fromJSON(object: object["start"] as! [String : Any])
        end.fromJSON(object: object["end"] as! [String : Any])
    }
    
    func toJSON() -> [String: Any]
	{
        var object = [String: Any]()
        
        object["start"] = start.toJSON()
        object["end"] = end.toJSON()
        
        return object
    }
    
    // make class Hashable
    var hashValue: Int
        {
        get {
            return ((self.worldStart.x + self.worldEnd.x)*(self.worldStart.y + self.worldEnd.y)).hashValue
        }
    }
    
    // make class Equatable
    public static func ==(lhs: Edge, rhs: Edge) -> Bool
    {
        return (lhs.start.x == rhs.start.x && lhs.end.x == rhs.end.x) && (lhs.start.y == rhs.start.y && lhs.end.y == rhs.end.y)
    }
}

class ShapeType
{
    var name = ""
    var id = ""

    func fromJSON(object: [String: Any])
    {
        name = object["name"] as! String
        id = object["id"] as! String
    }
    
    func toJSON() -> [String: Any] {
        var object = [String: Any]()

        object["name"] = name
        object["id"] = id

        return object
    }
}

class Shape
{
    var angles = [Angle]()
    var edges = [Edge]()
    var vertices = [Vector2]()
    var center = Vector2()
    var type = ShapeType()
    
    var worldCenter: Vector2
    {
        set(center)
        {
            self.worldCenter = center
            for edge in edges
            {
                edge.setWorldCoords(center: center)
            }
            
        }
        get
        {
            return self.worldCenter
        }
    }

    func fromJSON(object: [String: Any])
    {
        let dictArray = object["vertices"] as! [[String : Any]]
        vertices = [Vector2]()

        for v in dictArray
        {
            let v1 = Vector2()
            v1.fromJSON(object: v)
            vertices.append(v1)
        }
        
        type.fromJSON(object: object["type"] as! [String: Any])
    }
    
    func toJSON() -> [String: Any]
    {
        var object = [String: Any]()
        var verticDict = [[String: Any]]()
        
        for v in vertices
		{
            verticDict.append(v.toJSON())
        }
    
        object["vertices"] = verticDict
        object["center"] = center.toJSON()
        object["type"] = type.toJSON()
        
        return object
    }

    func calcAngles()
    {
        let count = vertices.count
        let countLess = count - 1
        
        var angleCollection = [Angle]()
        
        for index in 0..<count
        {
        
        /*
            Angle Order
            _________
           4|       |3
            |       |
            |       |
           1|_______|2
             
        */
            let vertex0 = vertices[(index + countLess) % count]
            let vertex1 = vertices[index]
            let vertex2 = vertices[(index + 1) % count]
        
            let v0x = vertex0.x - vertex1.x
            let v0y = vertex0.y - vertex1.y
            let v1x = vertex2.x - vertex1.x
            let v1y = vertex2.y - vertex1.y
        
            var angle = atan2(v0y, v0x) - atan2(v1y, v1x)
            if angle < 0.0
            {
                angle += π + π
            }
            
            let a = Angle()
            a.setRadian(r: angle)
            angleCollection.append(a)
        }

        angles = angleCollection
    }
    
    func calcEdges()
    {
        let count = vertices.count
        
        for i in 0..<count-1  {
            let e = Edge()
            e.setEdge(start: vertices[i], end: vertices[i+1], shape: self)
            edges.append(e)
        }
        
        let e = Edge()
        e.setEdge(start: vertices[count-1], end: vertices[0], shape: self)
        edges.append(e)
    }
    
    func calcCenter()
    {
        var x = 0.0
        var y = 0.0
        
        for v in vertices
        {
            x += v.x
            y += v.y
        }
        
        let count = Double(vertices.count)
        center.setVector(x: x/count, y: y/count)
    }
}

class World
{
    var name = ""
    var shapes = [Shape]()
    
    var generation = 1
    var generationShapes: [Int: [Shape]] = [0: [Shape]()]
    
    var edgeNeighbours: [Edge: [Shape]] = [Edge(): [Shape]()]
    var vertexNeighbours: [Vector2: [Shape]] = [Vector2(): [Shape]()]
    
    var scale: Int = 1
    
    
    func evolve() -> ([Vector2], [Shape])
    {

        generation = generation + 1
        var eVecs = [Vector2]()
        var eShapes = [Shape]()

        for shape in shapes
        {
            for edge in shape.edges
            {
                if (edgeNeighbours[edge]?.count)! < 2
                {
                    eVecs.append(edge.worldStart)
                    eVecs.append(edge.worldEnd)
                }
            }
        }
        
        return (eVecs, eShapes)
        
    }
    
    func addShape(shape: Shape, center: Vector2)
    {
        shape.worldCenter = center
        shapes.append(shape)
        addEdgeNeighbours(s: shape)
        addVerticesNeighbours(s: shape)
        generationShapes[generation]?.append(shape)
    }
    
    func addEdgeNeighbours(s: Shape)
    {
        for e in s.edges
        {
            edgeNeighbours[e]?.append(s)
        }
    }
    
    func addVerticesNeighbours(s: Shape)
    {
        for v in s.vertices
        {
                vertexNeighbours[v]?.append(s)
        }
    }
    
    func fromJSON(object: [String: Any])
	{
		if let worldObject = object["world"] as? [String: Any]
		{
			if let array = worldObject["shapes"] as? [[String : Any]]
			{
				shapes = [Shape]()

				for s in array
				{
					let s1 = Shape()
					s1.fromJSON(object: s)
					shapes.append(s1)
				}
			}
		}
	}

    func toJSON() -> [String: Any]
    {
        var object = [String: Any]()
        var worldObject = [String: Any]()
        object["name"] = name
        
        var shapeDict = [[String: Any]]()
        
        for s in shapes
        {
            shapeDict.append(s.toJSON())
        }
        
        object["shapes"] = shapeDict
        
        worldObject["world"] = object
        return worldObject
    }
}

//let exampleWorldFile: [String: Any] = [
//    "world": [
//        "name" : "testworld",
//        "shapes": [
//            [
//                "vertices": [
//                    [
//                        "x": 0.0,
//                        "y": 0.0
//                    ],
//                    [
//                        "x": 1.0,
//                        "y": 0.0
//                    ],
//                    [
//                        "x": 1.0,
//                        "y": 1.0
//                    ],
//                    [
//                        "x": 0.0,
//                        "y": 1.0
//                    ],
//                ],
//                "center": [
//                    "x": 0.0,
//                    "y": 0.0
//                ],
//                "type": [
//                    "name": "Square",
//                    "id": "90-90-90-90"
//                ]
//            ]
//        ]
//    ]
//]
