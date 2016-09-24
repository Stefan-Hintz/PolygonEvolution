//
//  World.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation
import JSONCodable

typealias Scalar = Double

class Vector2
{
    var x = 0.0
    var y = 0.0
    
    func setVector(x: Double, y: Double)
    {
        self.x = x
        self.y = y
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
    
}

class Edge
{
    
    var start = Vector2()
    var end = Vector2()

    func setEdge(start: Vector2, end: Vector2)
    {
        self.start = start
        self.end = end
    }
    
    func fromJSON(object: [String: Any])
    {
        
        start.fromJSON(object: object["start"] as! [String : Any])
        end.fromJSON(object: object["end"] as! [String : Any])
        
    }
    
    func toJSON() -> [String: Any] {
        var object = [String: Any]()
        
        object["start"] = start.toJSON()
        object["end"] = end.toJSON()
        
        return object
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
        
        for v in vertices {
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
        
        for variant in 0..<count
        {
        
        /*
            Angle Order
            _________
           4|       |3
            |       |
            |       |
           1|_______|2
             
        */
            let vertex0 = vertices[(variant + (countLess)) % vertices.count]
            let vertex1 = vertices[variant]
            let vertex2 = vertices[(variant + 1) % vertices.count]
        
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
            e.setEdge(start: vertices[i], end: vertices[i+1])
            edges.append(e)
        }
        
        let e = Edge()
        e.setEdge(start: vertices[count-1], end: vertices[0])
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
    
    func fromJSON(object: [String: Any])
    {
        var worldObject = object["world"] as! [String: Any]
        
        let dictArray = worldObject["shapes"] as! [[String : Any]]
        shapes = [Shape]()
        
        for s in dictArray
        {
            let s1 = Shape()
            s1.fromJSON(object: s)
            shapes.append(s1)
        }
    }


    func toJSON() -> [String: Any]
    {
        var object = [String: Any]()
        var worldObject = [String: Any]()
        object["name"] = name
        
        var shapeDict = [[String: Any]]()
        
        for s in shapes {
            shapeDict.append(s.toJSON())
        }
        
        worldObject["world"] = object
        return worldObject
    }
}

let exampleWorldFile: [String: Any] = [
    "world": [
        "name" : "testworld",
        "shapes": [
            [
                "vertices": [
                    [
                        "x": 0.0,
                        "y": 0.0
                    ],
                    [
                        "x": 1.0,
                        "y": 0.0
                    ],
                    [
                        "x": 1.0,
                        "y": 1.0
                    ],
                    [
                        "x": 0.0,
                        "y": 1.0
                    ],
                ],
                "center": [
                    "x": 0.0,
                    "y": 0.0
                ],
                "type": [
                    "name": "Square",
                    "id": "90-90-90-90"
                ]
            ]
        ]
    ]
]





