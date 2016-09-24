//
//  world.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation
import JSONJoy

public typealias Scalar = Float

public struct Vector2: JSONJoy {
    public var x: Scalar
    public var y: Scalar
    
    public init(_ decoder: JSONDecoder) throws {
        x = try decoder["x"].getFloat()
        y = try decoder["x"].getFloat()
    }
}

public struct Edge: JSONJoy {
    public var vertices: [Vector2]
    
    public init(_ decoder: JSONDecoder) throws {
        guard let _vertices = decoder["vertices"].array else {
            throw  JSONError.wrongType
        }
        
        var collect = [Vector2]()
        for vertDecoder in _vertices {
            try collect.append(Vector2(vertDecoder))
        }
        
        vertices = collect
    }
}

public struct ShapeType: JSONJoy {
    public var name: String
    public var id: String
    
    public init(_ decoder: JSONDecoder) throws {
        name = try decoder["name"].getString()
        id = try decoder["uuid"].getString()
    }
}

public struct Shape: JSONJoy{
    public var edges: [Edge]
    public var center: Vector2
    public var type: ShapeType
    
    public init(_ decoder: JSONDecoder) throws {
        
        guard let _edges = decoder["edges"].array else {throw JSONError.wrongType}
        var collect = [Edge]()
        for edgeDecoder in _edges {
            try collect.append(Edge(edgeDecoder))
        }
        edges = collect
        center = try Vector2(decoder["center"])
        type = try ShapeType(decoder["type"])
    }
}



class World
{
    var Shapes: Shape
    //var Worldfile: String
    
    init?(jsonString: String) {
        do {
            Shapes = try Shape(JSONDecoder(jsonString))
        } catch {
            return nil
        }
    }
}
