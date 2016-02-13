//
//  Providers.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-08.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// Returns an `MTLBuffer` object for a given length in bytes and resource options.
typealias BufferProvider = (length: Int, options: MTLResourceOptions) -> MTLBuffer

/// Returns an `MTLTexture` object for a given `MTLTextureDescriptor`.
typealias TextureProvider = (descriptor: MTLTextureDescriptor) -> MTLTexture

extension MTLDevice {
    
    /// Returns a new buffer provider that uses `self`.
    var basicBufferProvider: BufferProvider {
        return { (length, options) in
            self.newBufferWithLength(length, options: options)
        }
    }
    
    /// Returns a new texture provider that uses `self`.
    var basicTextureProvider: TextureProvider {
        return { descriptor in
            self.newTextureWithDescriptor(descriptor)
        }
    }
}