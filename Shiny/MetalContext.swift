//
//  MetalContext.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-28.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Foundation

/// Structure encapsulating properties 
/// essential to a Metal application.
public struct MetalContext {
    
    public let device: MTLDevice
    public let library: MTLLibrary
    public let commandQueue: MTLCommandQueue
    
    // Private memberwise initializer to force global
    // scope to use `MetalContext.new()`.
    private init(device: MTLDevice, library: MTLLibrary, commandQueue: MTLCommandQueue) {
        self.device = device
        self.library = library
        self.commandQueue = commandQueue
    }
}

public enum MetalContextCreationError: ErrorType {
    case DeviceNotAvailable
    case DefaultLibraryNotFound
}

public extension MetalContext {
    
    /// Creates a new `MetalContext` with environment defaults,
    /// throwing a `MetalContextCreationError` if one could not
    /// be created.
    static func new() throws -> MetalContext {
        
        guard let device = MTLCreateSystemDefaultDevice() else { throw MetalContextCreationError.DeviceNotAvailable }
        
        guard let library = device.newDefaultLibrary() else { throw MetalContextCreationError.DefaultLibraryNotFound }
        
        let commandQueue = device.newCommandQueue()
        
        return MetalContext(device: device, library: library, commandQueue: commandQueue)
    }
}
