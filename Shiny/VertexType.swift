//
//  Vertex.swift
//  MetalEffects
//
//  Created by James Taylor on 2016-02-02.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import PencilBox

/// A type that can be used as a vertex
/// by a `MeshType` instance.
public protocol VertexType {
    init()
}

/// A type that can be positioned in a coordinate system 
/// by it's `position` property.
public protocol Positionable {
    var position: Point<Float> { get set }
}

/// A type that can be assigned to a point in a texture
/// with it's `textureCoordinates` property.
public protocol Texturable {
    var textureCoordinates: Point<Float> { get set }
}


