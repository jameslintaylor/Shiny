//
//  MeshBufferContainer.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-07.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// A structure that contains vertex and index buffers 
/// for a `MeshType` instance.
public struct MeshBufferContainer<Mesh: MeshType> {
    let mesh: Mesh
    
    public private(set) var vertexBuffer: MTLBuffer
    public private(set) var indexBuffer: MTLBuffer
}

// + Initializers
public extension MeshBufferContainer {
    init(mesh: Mesh, @noescape provider: BufferProvider) {
        self.mesh = mesh
        
        // create buffers
        vertexBuffer = provider(length: mesh.vertexDataSize, options: .CPUCacheModeDefaultCache)
        indexBuffer = provider(length: mesh.indexDataSize, options: .CPUCacheModeDefaultCache)
        
        // copy data into buffers
        memcpy(vertexBuffer.contents(), mesh.vertices, mesh.vertexDataSize)
        memcpy(indexBuffer.contents(), mesh.indices, mesh.indexDataSize)
    }
}

// + Computed properties
public extension MeshBufferContainer {
    
    /// The number of vertices in the vertex buffer.
    var vertexCount: Int {
        return mesh.vertices.count
    }
    
    /// The number of indices in the index buffer.
    var indexCount: Int {
        return mesh.indices.count
    }
    
    /// The `MTLIndexType` of the indices.
    var indexType: MTLIndexType {
        return mesh.indexType
    }
}