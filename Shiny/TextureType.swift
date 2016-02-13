//
//  TextureType.swift
//  MetalEffects
//
//  Created by James Taylor on 2016-02-06.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import PencilBox
import Metal

// Geometry typealiases
public typealias TextureIndex = Point<Int>
public typealias TextureSize = Size<Int>
public typealias TextureRegion = Rectangle<Int>
public typealias TextureBounds = Rectangle<Int>

/// A wrapping type that houses a `MTLTexture` object and 
/// exposes a few convenient methods for getting and setting 
/// it's raw bytes.
public protocol TextureType {
    /// The type of channel in the pixel.
    typealias Channel: PixelChannelType
    
    /// The number of channels per pixel. 
    ///
    /// - Important: 
    /// This property, along with `Channel` must match up with the 
    /// texture object's pixel format otherwise behaviour is undefined. 
    /// i.e. for a texture with pixel format `BGRA8Unorm`, this property
    /// and the `Channel` property should be 4 and `UInt8` respectively.
    var channelsPerPixel: Int { get }
    
    /// The backing `MTLTexture` object.
    var texture: MTLTexture { get }
}

// + Computed properties
public extension TextureType {
    
    /// The width of the texture in pixels.
    var width: Int {
        return texture.width
    }
    
    /// The height of the texture in pixels.
    var height: Int {
        return texture.height
    }
    
    /// The bounds of the texture with dimensions in pixels.
    var bounds: TextureBounds {
        return Rectangle(TextureIndex.Zero, TextureSize(texture.width, texture.height))
    }
    
    /// The size of an individual pixel in bytes.
    var pixelSizeInBytes: Int {
        return sizeof(Channel) * channelsPerPixel
    }
}

// MARK: - Byte modifying methods

public extension TextureType where Channel: Zeroable {
    
    /// Returns the bytes in `self`'s backing texture in `region`.
    ///
    /// - Precondition: 
    /// `region` must be contained within the bounds of `self`.
    func getBytesInRegion(region: TextureRegion) -> [Channel] {
        precondition(bounds.contains(region), "region (\(region)) must be contained within the bounds of the texture (\(bounds))")
        
        var bytes = [Channel](count: region.area * channelsPerPixel, repeatedValue: Channel.Zero)
        texture.getBytes(&bytes, bytesPerRow: region.width * pixelSizeInBytes, fromRegion: MTLRegion(region), mipmapLevel: 0)
        return bytes
    }
    
    /// Replaces the bytes in `self`'s backing texture in `region` with `bytes`.
    ///
    /// - Precondition:
    /// `region` must be contained within the bounds of `self`.
    func replaceBytesInRegion(region: TextureRegion, withBytes bytes: [Channel]) {
        precondition(bounds.contains(region), "region must be contained within the bounds of the texture")
        
        if bytes.count != region.area * channelsPerPixel {
            print("warning: replacing a region of \(region.area) pixels with \(region.area * channelsPerPixel) channels with bytes containing data for \(bytes.count/channelsPerPixel) pixels and \(bytes.count) channels.")
        }
        
        texture.replaceRegion(MTLRegion(region), mipmapLevel: 0, withBytes: bytes, bytesPerRow: region.width * sizeof(Channel) * channelsPerPixel)
    }
    
    /// Returns the individual pixel bytes in `self`'s backing texture at `index`.
    ///
    /// - Precondition:
    /// `index` must be contained within the bounds of `self`.
    func getBytesAtIndex(index: TextureIndex) -> [Channel] {
        precondition(bounds.contains(index), "index (\(index)) must be contained within the bounds of the texture (\(bounds))")
        
        let region = TextureRegion(index, TextureSize(1, 1))
        return getBytesInRegion(region)
    }
    
    /// Replaces the individual pixel's bytes in `self`'s backing texture at `index` with `bytes`.
    ///
    /// - Precondition:
    /// `index` must be contained within the bounds of `self`.
    func replaceBytes(at index: TextureIndex, with bytes: [Channel]) {
        precondition(bounds.contains(index), "index (\(index)) must be contained within the bounds of the texture (\(bounds))")
        
        let region = TextureRegion(index, TextureSize(1, 1))
        replaceBytesInRegion(region, withBytes: bytes)
    }
}

// MARK: - MTLOrigin, MTLSize, MTLRegion convenience initializers

public extension MTLOrigin {
    init(_ point: TextureIndex) {
        self.x = point.x
        self.y = point.y
        self.z = 0
    }
}

public extension MTLSize {
    init(_ size: TextureSize) {
        self.width = size.width
        self.height = size.height
        self.depth = 1
    }
}

public extension MTLRegion {
    init(_ region: TextureRegion) {
        self.origin = MTLOrigin(region.origin)
        self.size = MTLSize(region.size)
    }
}

// MARK: - MTLCommandEncoder + set texture

// + MTLComputeCommandEncoder
public extension MTLComputeCommandEncoder {
    func setTexture<T: TextureType>(texture: T, atIndex index: Int) {
        setTexture(texture.texture, atIndex: index)
    }
}

// + MTLRenderCommandEncoder
public extension MTLRenderCommandEncoder {
    func setVertexTexture<T: TextureType>(texture: T, atIndex index: Int) {
        setVertexTexture(texture.texture, atIndex: index)
    }
    
    func setFragmentTexture<T: TextureType>(texture: T, atIndex index: Int) {
        setFragmentTexture(texture.texture, atIndex: index)
    }
}
