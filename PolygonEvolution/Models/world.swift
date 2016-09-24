//
//  world.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation
import JSONCodable

public typealias Scalar = Float

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
    public var vertices: [Vector2]
}

extension Edge: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        vertices = try decoder.decode("vertices")
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
    public var edges: [Edge]
    public var center: Vector2
    public var type: ShapeType
}


extension Shape: JSONDecodable {
    public init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        edges = try decoder.decode("edges")
        center = try decoder.decode("center")
        type = try decoder.decode("type")
    }
}


class World
{
    var shapes: Shape
    //var Worldfile: String
    
    init?(jsonString: [String: Any]) {
        do {
            try shapes = try Shape(object: jsonString)
        } catch {
            return nil
        }
    }
    
}
