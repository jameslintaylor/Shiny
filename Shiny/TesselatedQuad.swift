//
//  TesselatedQuad.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-14.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import simd
import PencilBox

public struct TesselatedQuad<Vertex: VertexType where Vertex: Positionable>: MeshType {
    public var vertices: [Vertex]
    public var indices: [UInt32]
    
    public init(frame: Rectangle<Float>, dimensions: Size<Int>) {
        self.vertices = [Vertex](count: (dimensions.width + 1) * (dimensions.height + 1), repeatedValue: Vertex())
        self.indices = generateTesselatedIndicesWithDimensions(dimensions)
        
        // Position the vertices
        let positions = generateTesselatedCoordinatesInFrame(frame, withDimensions: dimensions)
        self.vertices = zip(self.vertices, positions).map() {
            var vertex = $0
            vertex.position = Point(x: $1.x, y: $1.y)
            return vertex
        }
    }
}

public extension TesselatedQuad where Vertex: Texturable {
    init(frame: Rectangle<Float>, textureFrame: Rectangle<Float>, dimensions: Size<Int>) {
        self.init(frame: frame, dimensions: dimensions)
        
        // Assign texture coordinates to the vertices
        let textureCoordinates = generateTesselatedCoordinatesInFrame(textureFrame, withDimensions: dimensions)
        self.vertices = zip(self.vertices, textureCoordinates).map() {
            var vertex = $0
            vertex.textureCoordinates = Point(x: $1.x, y: $1.y)
            return vertex
        }
    }
}

private func generateTesselatedCoordinatesInFrame(frame: Rectangle<Float>, withDimensions dimensions: Size<Int>, flippedHorizontally: Bool = false, flippedVertically: Bool = false) -> [float2] {
    var coordinates = [float2]()
    
    let stride = Size(
        width: frame.size.width/Float(dimensions.width),
        height: frame.size.height/Float(dimensions.height)
    )
    
    for j in 0 ... dimensions.height {
        var row = [float2]()
        for i in 0 ... dimensions.width {
            let x = frame.origin.x + (stride.width * Float(i))
            let y = frame.origin.y + (stride.height * Float(j))
            flippedHorizontally ? row.insert([x, y], atIndex: 0) : row.append([x, y])
        }
        
        flippedVertically ? coordinates.insertContentsOf(row, at: 0) : coordinates.appendContentsOf(row)
    }
    
    return coordinates
}

private func generateTesselatedIndicesWithDimensions(dimensions: Size<Int>) -> [UInt32] {
    var indices = [UInt32]()
    
    // inclusive width and height
    let w = UInt32(dimensions.width + 1)
    let h = UInt32(dimensions.height + 1)
    
    for y in 0 ..< (h - 1) {
        for x in 0 ..< (w - 1) {
            let index = (w * y) + x
            
            // bottom right
            indices.append(index)
            indices.append(index + w + 1)
            indices.append(index + 1)
            
            // top left
            indices.append(index)
            indices.append(index + w)
            indices.append(index + w + 1)
        }
    }
    
    return indices
}

// Don't know a different way to do this :(
private func generateTesselatedIndicesWithDimensions(dimensions: Size<Int>) -> [UInt16] {
    var indices = [UInt16]()
    
    // inclusive width and height
    let w = UInt16(dimensions.width + 1)
    let h = UInt16(dimensions.height + 1)
    
    for y in 0 ..< (h - 1) {
        for x in 0 ..< (w - 1) {
            let index = (w * y) + x
            
            // bottom right
            indices.append(index)
            indices.append(index + w + 1)
            indices.append(index + 1)
            
            // top left
            indices.append(index)
            indices.append(index + w)
            indices.append(index + w + 1)
        }
    }
    
    return indices
}
