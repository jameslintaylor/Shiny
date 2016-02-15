//
//  UniformsBufferContainer.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

public struct UniformsBufferContainer<Uniforms: UniformsType> {
    
    public var uniforms: Uniforms {
        didSet {
            updateBuffer()
        }
    }
    
    private var buffer: MTLBuffer
    
    public init(uniforms: Uniforms, provider: BufferProvider) {
        self.uniforms = uniforms
        self.buffer = provider(length: sizeof(Uniforms), options: .CPUCacheModeDefaultCache)
        
        updateBuffer()
    }
    
    private mutating func updateBuffer() {
        let bufferPointer = buffer.contents()
        memcpy(bufferPointer, &uniforms, sizeof(Uniforms))
    }
}

// MTLRenderCommandEncoder convenience
public extension MTLRenderCommandEncoder {
    func setVertexBuffer<Uniforms: UniformsType>(buffer: UniformsBufferContainer<Uniforms>, atIndex index: Int) {
        setVertexBuffer(buffer.buffer, offset: 0, atIndex: index)
    }
}