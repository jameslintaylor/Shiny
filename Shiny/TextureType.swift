//
//  TextureType.swift
//  MetalEffects
//
//  Created by James Taylor on 2016-02-06.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import PencilBox

import Metal
import MetalPerformanceShaders

// Geometry typealiases
public typealias TextureIndex = Point<Int>
public typealias TextureSize = Size<Int>
public typealias TextureRegion = Rectangle<Int>
public typealias TextureBounds = Rectangle<Int>

/// A wrapper type that houses an `MTLTexture` object and
/// exposes methods for getting and setting it's bytes.
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
        return Rectangle(origin: TextureIndex.zero, size: TextureSize(width: texture.width, height: texture.height))
    }
    
    /// The size of an individual pixel in bytes.
    var pixelSizeInBytes: Int {
        return sizeof(Channel) * channelsPerPixel
    }
}

// MARK: - Byte modifying methods

public extension TextureType {
    
    /// Returns the bytes in `self`'s backing texture in `region`. The given
    /// `region` parameter should be framed in reference to the texture's
    /// native resolution or `bounds`.
    ///
    /// - Precondition:
    /// `region` must be contained within the bounds of `self`.
    func getBytes(inout bytes: [Channel], inRegion region: TextureRegion, mipmapLevel: Int = 0) -> [Channel] {
        precondition(bounds.contains(region), "region (\(region)) must be contained within the bounds of the texture (\(bounds))")
        
        texture.getBytes(&bytes, bytesPerRow: region.width * pixelSizeInBytes, fromRegion: MTLRegion(region), mipmapLevel: mipmapLevel)
        return bytes
    }
    
    /// Returns the individual pixel bytes in `self`'s backing texture at `index`.
    /// The given `index` paremeter should be indexed relative to the texture's
    /// native resolution or `bounds`.
    ///
    /// - Precondition:
    /// `index` must be contained within the bounds of `self`.
    func getBytes(inout bytes: [Channel], atIndex index: TextureIndex, mipmapLevel: Int = 0) -> [Channel] {
        precondition(bounds.contains(index), "index (\(index)) must be contained within the bounds of the texture (\(bounds))")
        
        let region = TextureRegion(origin: index, size: TextureSize(width: 1, height: 1))
        return getBytes(&bytes, inRegion: region, mipmapLevel: mipmapLevel)
    }
    
    /// Replaces the bytes in `self`'s backing texture in `region` with `bytes`.
    /// The given `region` parameter should be framed in reference to the texture's
    /// native resolution or `bounds`.
    ///
    /// - Precondition:
    /// `region` must be contained within the bounds of `self`.
    func replaceBytesInRegion(region: TextureRegion, mipmapLevel: Int = 0, withBytes bytes: [Channel]) {
        precondition(bounds.contains(region), "region must be contained within the bounds of the texture")
        
        assert(region.area/pow(2, mipmapLevel * 2) == bytes.count/channelsPerPixel, "Failed assertion: attempting to replace (\(region.area/pow(2, mipmapLevel * 2))) pixels with bytes for (\(bytes.count/channelsPerPixel)) pixels.")
        
        texture.replaceRegion(MTLRegion(region), mipmapLevel: mipmapLevel, withBytes: bytes, bytesPerRow: region.width * sizeof(Channel) * channelsPerPixel)
    }
    
    /// Replaces the individual pixel's bytes in `self`'s backing texture at `index` with `bytes`.
    /// The given `index` parameter should be indexed relative to the texture's native resolution
    /// or `bounds`.
    ///
    /// - Precondition:
    /// `index` must be contained within the bounds of `self`.
    func replaceBytes(at index: TextureIndex, mipmapLevel: Int = 0, with bytes: [Channel]) {
        precondition(bounds.contains(index), "index (\(index)) must be contained within the bounds of the texture (\(bounds))")
        
        let region = TextureRegion(origin: index, size: TextureSize(width: 1, height: 1))
        replaceBytesInRegion(region, mipmapLevel: mipmapLevel, withBytes: bytes)
    }
}

public extension TextureType where Channel: ZeroRepresentable {
    
    /// Returns the bytes in `self`'s backing texture in `region`. The given
    /// `region` parameter should be framed in reference to the texture's 
    /// native resolution or `bounds`.
    ///
    /// - Precondition: 
    /// `region` must be contained within the bounds of `self`.
    func getBytesInRegion(region: TextureRegion, mipmapLevel: Int = 0) -> [Channel] {
        precondition(bounds.contains(region), "region (\(region)) must be contained within the bounds of the texture (\(bounds))")
        
        var bytes = [Channel](count: region.area * channelsPerPixel, repeatedValue: Channel.zero)
        texture.getBytes(&bytes, bytesPerRow: region.width * pixelSizeInBytes, fromRegion: MTLRegion(region), mipmapLevel: mipmapLevel)
        return bytes
    }
    
    /// Returns the individual pixel bytes in `self`'s backing texture at `index`.
    /// The given `index` paremeter should be indexed relative to the texture's
    /// native resolution or `bounds`.
    ///
    /// - Precondition:
    /// `index` must be contained within the bounds of `self`.
    func getBytesAtIndex(index: TextureIndex, mipmapLevel: Int = 0) -> [Channel] {
        precondition(bounds.contains(index), "index (\(index)) must be contained within the bounds of the texture (\(bounds))")
        
        let region = TextureRegion(origin: index, size: TextureSize(width: 1, height: 1))
        return getBytesInRegion(region, mipmapLevel: mipmapLevel)
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

// MARK: - MTLCommandEncoder convenience

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

// MARK: - MetalPerformanceShaders convenience
public extension MPSUnaryImageKernel {
    func encodeToCommandBuffer<T: TextureType, U: TextureType>(commandBuffer: MTLCommandBuffer, sourceTexture: T, destinationTexture: U) {
        encodeToCommandBuffer(commandBuffer, sourceTexture: sourceTexture.texture, destinationTexture: destinationTexture.texture)
    }
}

// MARK: - Helpers
private func pow(x: Int, _ y: Int) -> Int {
    return Int(pow(Double(x), Double(y)))
}
