//
//  PixelChannelType.swift
//  Zeno
//
//  Created by James Taylor on 2016-02-08.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// A type that can represent a channel of pixel data in 
/// a `TextureType` instance.
public protocol PixelChannelType {}

// + Standard library conformance

extension Int8: PixelChannelType {}
extension Int16: PixelChannelType {}
extension Int32: PixelChannelType {}

extension UInt8: PixelChannelType {}
extension UInt16: PixelChannelType {}
extension UInt32: PixelChannelType {}

extension Float: PixelChannelType {}