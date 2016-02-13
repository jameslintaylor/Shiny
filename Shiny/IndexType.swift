//
//  IndexType.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-12.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import Metal

/// A type that maps one-to-one with a corresponding `MTLIndexType`
/// and that can be used an index by a 'MeshType' instance.
protocol IndexType {
    static var equivalentMTLIndexType: MTLIndexType { get }
}

extension UInt16: IndexType {
static var equivalentMTLIndexType: MTLIndexType {
    return .UInt16
    }
}

extension UInt32: IndexType {
static var equivalentMTLIndexType: MTLIndexType {
    return .UInt32
    }
}