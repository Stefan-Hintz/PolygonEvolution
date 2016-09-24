//
//  world.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation


public typealias Scalar = Float

public struct Vector2 {
    public var x: Scalar
    public var y: Scalar
}

public typealias Edge = [Vector2]


public struct Shape {
    public var edges: [Edge]
    public var center: Vector2
    public var id: UUID
}



class World
{
    //var Shapes: Shape
    var Worldfile: String
    
    
    init(file: String) {
        self.Worldfile = file
    }
}
