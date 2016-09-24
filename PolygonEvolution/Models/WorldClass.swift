//
//  WorldClass.swift
//  PolygonEvolution
//
//  Created by Morris Winkler on 24/09/16.
//  Copyright © 2016 Stefan Hintz. All rights reserved.
//

import Foundation


class WorldClass
{
    var worldFile = try! WorldFile(object: exampleWorldFile)
    var world = try! World(object: exampleWorld)
    
    init() {
    }
    
    func loadJSON(JSONdict: [String: Any]) throws {
        worldFile = try! WorldFile(object: JSONdict)
        world = worldFile.world
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

let exampleWorld: [String: Any] = [
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

