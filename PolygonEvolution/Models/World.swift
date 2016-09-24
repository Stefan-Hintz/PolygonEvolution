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

struct Vector2 {
    var x: Scalar
    var y: Scalar
}

extension Vector2: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
            x = try decoder.decode("x")
            y = try decoder.decode("y")
    }
}

struct Edge {
    var start: Vector2
    var end: Vector2
}

extension Edge: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        start = try decoder.decode("start")
        end = try decoder.decode("end")
    }
}

struct ShapeType {
    var name: String
    var id: String
}

extension ShapeType: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        name = try decoder.decode("name")
        id = try decoder.decode("id")
    }
}

struct Shape{
    var angles = [Angle]()
    var edges: [Edge]
    var vertices: [Vector2]
    var center: Vector2
    var type: ShapeType
    
    mutating func genEdges() {
        
        let count = vertices.count
        
        for i in 0..<count-2  {
            edges.append(Edge(start: vertices[i], end: vertices[i+1]))
        }
        edges.append(Edge(start:vertices[count-1], end: vertices[0]))
    }
}

extension Shape: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        vertices = try decoder.decode("vertices")
        center = try decoder.decode("center")
        type = try decoder.decode("type")
    
        angles = [Angle]()
        edges = [Edge]()
        self.genEdges()
    }
}

struct World
{
    var name: String
    var shapes: [Shape]
   

}

extension World: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        name = try decoder.decode("name")
        shapes = try decoder.decode("shapes")
    }
}


struct WorldFile
{
    var world: World
    
}

extension WorldFile: JSONDecodable {
    init(object: JSONObject) throws {
        let decoder = JSONDecoder(object: object)
        world = try decoder.decode("world")
    }
}





