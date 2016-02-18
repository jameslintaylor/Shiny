//
//  UniformsBufferContainer.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// A structure containing a `UniformsType` instance and exposing
/// properties and methods for updating it's `uniforms` and passing
/// it's associated `MTLBuffer` object.
public struct UniformsBufferContainer<Uniforms: UniformsType> {
    
    public var uniforms: Uniforms {
        didSet {
            updateBuffers()
        }
    }
    
    private var bufferIndex: Int = 0
    private var buffers: [MTLBuffer]
    
    public init(uniforms: Uniforms, provider: BufferProvider, capacity: Int = 1) {
        self.uniforms = uniforms
        self.buffers = (0 ..< capacity).map { _ in provider(length: sizeof(Uniforms), options: .StorageModeShared) }
        updateBuffers()
    }
    
    private mutating func updateBuffers() {
        for buffer in buffers {
            let bufferPointer = buffer.contents()
            memcpy(bufferPointer, &uniforms, sizeof(Uniforms))
        }
    }
    
    /// Returns the next available buffer.
    public mutating func nextBuffer() -> MTLBuffer {
        defer { bufferIndex = (bufferIndex + 1) % buffers.count }
        return buffers[bufferIndex]
    }
}
