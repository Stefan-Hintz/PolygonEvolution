//
//  World.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation
import JSONCodable

public typealias Scalar = Double

public struct Vector2 {
    public var x: Scalar
    public var y: Scalar
}

extension Vector2: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
            x = try decoder.decode("x")
            y = try decoder.decode("y")
    }
}

public struct Edge {
    var start: Vector2
    var end: Vector2
}

extension Edge: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        start = try decoder.decode("start")
        end = try decoder.decode("end")
    }
}

public struct ShapeType {
    public var name: String
    public var id: String
}

extension ShapeType: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        name = try decoder.decode("name")
        id = try decoder.decode("id")
    }
}

public struct Shape{
    var angles = [Angle]()
    public var edges: [Edge]
    public var vertices: [Vector2]
    public var center: Vector2
    public var type: ShapeType
    
    mutating func genEdges() {
        
        let count = vertices.count
        
        for i in 0..<count-2  {
            edges.append(Edge(start: vertices[i], end: vertices[i+1]))
        }
        edges.append(Edge(start:vertices[count-1], end: vertices[0]))
    }
}

extension Shape: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        vertices = try decoder.decode("vertices")
        center = try decoder.decode("center")
        type = try decoder.decode("type")
    
        angles = [Angle]()
        edges = [Edge]()
        self.genEdges()
    }
}

public struct World
{
    var name: String
    var shapes: [Shape]
   

}

extension World: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        name = try decoder.decode("name")
        shapes = try decoder.decode("shapes")
    }
}


public struct WorldFile
{
    var world: World
    //var Worldfile: String
    
}

extension WorldFile: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        world = try decoder.decode("world")
    }
}





