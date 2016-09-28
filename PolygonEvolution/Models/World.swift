//
//  World.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation

typealias Scalar = Double

struct Center
{
    var x = 0.0
    var y = 0.0
    
    
    mutating func set(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
    
    mutating func fromJSON(object: [String: Any])
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
}

class Vector2: Hashable
{
    // keep reference to shape
    var shape = Shape()
    var x = 0.0
    var y = 0.0
    
    
    var worldX: Scalar
        {
        get
        {
            return x + shape.worldCenter.x
        }
    }
    
    var worldY: Scalar
        {
        get
        {
            return y + shape.worldCenter.y
        }
    }
    
    func set(x: Double, y: Double, shape: Shape)
    {
        self.x = x
        self.y = y
        self.shape = shape
    }
    
    func set(x: Double, y: Double)
    {
        self.x = x
        self.y = y
    }
    
    func add(vector2: Vector2)
    {
        x = x + vector2.x
        y = y + vector2.y
    }
    
    func add(center: Center)
    {
        x = x + center.x
        y = x + center.y
    }
    
    func sub(vector2: Vector2)
    {
        x = x - vector2.x
        y = y - vector2.y
    }
    
    func scale(scale: Double)
    {
        x = x*scale
        y = y*scale
    }
    
    func fromJSON(object: [String: Any], shape: Shape)
    {
        if let x = object["x"] as? Scalar
        {
            self.x = x
        }

        if let y = object["y"] as? Scalar
        {
            self.y = y
        }
        
        self.shape = shape
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
        get
        {
            // generate a unique id of worldX-worldY
            //
            // TODO: make this safe for rounding error by defining a treshold distance for vertice merging
            var unique = 0.0
            unique += worldX * 1000000000000
            unique += worldY * 1000000000
            
            return Int(unique)
        }
    }
    
    // make class Equatable
    public static func ==(lhs: Vector2, rhs: Vector2) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
    }
}

class Edge: Hashable
{
    var start = Vector2()
    var end = Vector2()

    func set(start: Vector2, end: Vector2)
    {
        self.start = start
        self.end = end
    }
    
    // make class Hashable
    var hashValue: Int
        {
        get {
            // generate a unique id of worldStart.x-worldStart.y-worldEnd.x-worldEnd.y
            //
            // TODO: make this safe for rounding error by defining a treshold distance for vertice merging
            var unique = 0.0
            unique += start.worldX * 1000000000000
            unique += start.worldY * 1000000000
            unique += end.worldX * 1000000
            unique += end.worldY * 1000
            
            return Int(unique)
        }
    }
    
    // make class Equatable
    public static func ==(lhs: Edge, rhs: Edge) -> Bool
    {
        return lhs.hashValue == rhs.hashValue
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
    var center = Center()
    var worldCenter = Center()
    var type = ShapeType()
    
    
    func fromJSON(object: [String: Any])
    {
        let dictArray = object["vertices"] as! [[String : Any]]
        vertices = [Vector2]()

        for v in dictArray
        {
            let v1 = Vector2()
            v1.fromJSON(object: v, shape: self)
            vertices.append(v1)
        }
        
        var c = Center()
        c.fromJSON(object: object["world_center"] as! [String : Any])
        worldCenter = c
        
        type.fromJSON(object: object["type"] as! [String: Any])
    }
    
    func toJSON() -> [String: Any]
    {
        var object = [String: Any]()
        var vertexDict = [[String: Any]]()
        
        for v in vertices
		{
            vertexDict.append(v.toJSON())
        }
    
        object["vertices"] = vertexDict
        object["center"] = center.toJSON()
        object["world_center"] = worldCenter.toJSON()
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
            e.set(start: vertices[i], end: vertices[i+1])
            edges.append(e)
        }
        
        let e = Edge()
        e.set(start: vertices[count-1], end: vertices[0])
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
        center.set(x: x/count, y: y/count)
    }
    
    func calc() {
        calcAngles()
        calcEdges()
        calcCenter()
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
        let eShapes = [Shape]()

        for shape in shapes
        {
            for edge in shape.edges
            {
                if (edgeNeighbours[edge]?.count)! < 2
                {
                    
                    if !eVecs.contains(edge.start)
                    {
                    eVecs.append(edge.start)
                    }
                    if !eVecs.contains(edge.end)
                    {
                    eVecs.append(edge.end)
                    }
                }
            }
        }
        
        return (eVecs, eShapes)
        
    }
    
    func addShape(shape: Shape, center: Center)
    {
        shape.calc()
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
            
            // swift quirks, how to append to an unitilized array
            if var arr = edgeNeighbours[e]
            {
                arr.append(s)
            }else
            {
                edgeNeighbours[e] = [s]
            }
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
                    addShape(shape: s1, center: s1.worldCenter)
                    
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
