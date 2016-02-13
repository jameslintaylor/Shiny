//
//  MeshType.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-12.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// A type that contains vertex and index data.
protocol MeshType {
    typealias Vertex: VertexType
    typealias Index: IndexType
    
    var vertices: [Vertex] { get }
    var indices: [Index] { get }
}

// + Computed properties
extension MeshType {
    
    /// The size of the vertices in bytes.
    var vertexDataSize: Int {
        return vertices.count * sizeof(Vertex)
    }
    
    /// The size of the indices in bytes.
    var indexDataSize: Int {
        return indices.count * sizeof(Index)
    }
    
    /// The corresponding `MTLIndexType` of the indices.
    var indexType: MTLIndexType {
        return Index.equivalentMTLIndexType
    }
}