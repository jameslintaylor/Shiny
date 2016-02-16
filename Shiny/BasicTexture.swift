//
//  BasicTexture.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-13.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import CoreGraphics

/// A 2-Dimensional texture with the BGRA8 pixel format.
public struct BasicBGRA8Texture: TextureType {

    public typealias Channel = UInt8
    public let channelsPerPixel: Int = 4
    
    // var in order to pass this texture as a mutable pointer for an in-place kernel function.
    public var texture: MTLTexture
    
    /// Initialize a new BGRA8 texture with dimensions given by `size`.
    public init(size: TextureSize, @noescape provider: TextureProvider) {
        let descriptor = MTLTextureDescriptor.texture2DDescriptorWithPixelFormat(.BGRA8Unorm, width: size.width, height: size.height, mipmapped: false)
        texture = provider(descriptor: descriptor)
    }
}

public extension BasicBGRA8Texture {
    
    /// Initializes a new texture with the bytes in the assets image named `imageName`.
    ///
    /// This initializer fails if no valid image is found.
    init?(named name: String, @noescape provider: TextureProvider) {
        guard let image = UIImage(named: name)?.CGImage else { return nil  }
        let width = CGImageGetWidth(image)
        let height = CGImageGetHeight(image)
        
        self.init(size: TextureSize(width: width, height: height), provider: provider)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        var bytes = [UInt8](count: width * height * 4, repeatedValue: 0)
        let bytesPerRow = width * 4
        let bitsPerComponent = 8
        let context = CGBitmapContextCreate(&bytes, width, height, bitsPerComponent, bytesPerRow, colorSpace, CGImageAlphaInfo.PremultipliedLast.rawValue | CGBitmapInfo.ByteOrder32Big.rawValue)
        
        // Flip the context
        CGContextTranslateCTM(context, 0, CGFloat(height))
        CGContextScaleCTM(context, 1, -1)
        
        CGContextDrawImage(context, CGRect(x: 0, y: 0, width: CGFloat(width), height: CGFloat(height)), image)
        
        // Copy bytes into texture
        replaceBytesInRegion(bounds, withBytes: bytes)
    }
}

// MARK: - Helpers
