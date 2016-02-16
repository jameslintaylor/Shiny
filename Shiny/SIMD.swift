//
//  SIMD.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import simd

// MARK: - 3x3

public extension matrix_float3x3 {
    
    // Row 1
    var m11: Float { return columns.0.x }
    var m12: Float { return columns.1.x }
    var m13: Float { return columns.2.x }
    
    // Row 2
    var m21: Float { return columns.0.y }
    var m22: Float { return columns.1.y }
    var m23: Float { return columns.2.y }
    
    // Row 3
    var m31: Float { return columns.0.z }
    var m32: Float { return columns.1.z }
    var m33: Float { return columns.2.z }
    
    init(m11: Float, m12: Float, m13: Float, m21: Float, m22: Float, m23: Float, m31: Float, m32: Float, m33: Float) {
        self.columns.0 = [m11, m21, m31]
        self.columns.1 = [m12, m22, m32]
        self.columns.2 = [m13, m23, m33]
    }
}

public extension matrix_float3x3 {
    
    var rows: (vector_float3, vector_float3, vector_float3) {
        let r1: vector_float3 = [columns.0.x, columns.1.x, columns.2.x]
        let r2: vector_float3 = [columns.0.y, columns.1.y, columns.2.y]
        let r3: vector_float3 = [columns.0.z, columns.1.z, columns.2.z]
        return (r1, r2, r3)
    }
    
    init(rows: (vector_float3, vector_float3, vector_float3)) {
        self.columns.0 = [rows.0.x, rows.1.x, rows.2.x]
        self.columns.1 = [rows.0.y, rows.1.y, rows.2.y]
        self.columns.2 = [rows.0.z, rows.1.z, rows.2.z]
    }
}

// MARK: - 4x4

// + Index addressing
public extension matrix_float4x4 {
    
    // Row 1
    var m11: Float { return columns.0.x }
    var m12: Float { return columns.1.x }
    var m13: Float { return columns.2.x }
    var m14: Float { return columns.3.x }
    
    // Row 2
    var m21: Float { return columns.0.y }
    var m22: Float { return columns.1.y }
    var m23: Float { return columns.2.y }
    var m24: Float { return columns.3.y }
    
    // Row 3
    var m31: Float { return columns.0.z }
    var m32: Float { return columns.1.z }
    var m33: Float { return columns.2.z }
    var m34: Float { return columns.3.z }
    
    // Row 4
    var m41: Float { return columns.0.w }
    var m42: Float { return columns.1.w }
    var m43: Float { return columns.2.w }
    var m44: Float { return columns.3.w }
    
    init(m11: Float, m12: Float, m13: Float, m14: Float, m21: Float, m22: Float, m23: Float, m24: Float, m31: Float, m32: Float, m33: Float, m34: Float, m41: Float, m42: Float, m43: Float, m44: Float) {
        self.columns.0 = [m11, m21, m31, m41]
        self.columns.1 = [m12, m22, m32, m42]
        self.columns.2 = [m13, m23, m33, m43]
        self.columns.3 = [m14, m24, m34, m44]
    }
}

// + Row addressing
public extension matrix_float4x4 {
    
    var rows: (vector_float4, vector_float4, vector_float4, vector_float4) {
        let r1: vector_float4 = [columns.0.x, columns.1.x, columns.2.x, columns.3.x]
        let r2: vector_float4 = [columns.0.y, columns.1.y, columns.2.y, columns.3.y]
        let r3: vector_float4 = [columns.0.z, columns.1.z, columns.2.z, columns.3.z]
        let r4: vector_float4 = [columns.0.w, columns.1.w, columns.2.w, columns.3.w]
        return (r1, r2, r3, r4)
    }
    
    init(rows: (vector_float4, vector_float4, vector_float4, vector_float4)) {
        self.columns.0 = [rows.0.x, rows.1.x, rows.2.x, rows.3.x]
        self.columns.1 = [rows.0.y, rows.1.y, rows.2.y, rows.3.y]
        self.columns.2 = [rows.0.z, rows.1.z, rows.2.z, rows.3.z]
        self.columns.3 = [rows.0.w, rows.1.w, rows.2.w, rows.3.w]
    }
}

// + Upper left matrix
public extension matrix_float4x4 {
    
    func upperLeft() -> matrix_float3x3 {
        let r1: vector_float3 = [columns.0.x, columns.1.x, columns.2.x]
        let r2: vector_float3 = [columns.0.y, columns.1.y, columns.2.y]
        let r3: vector_float3 = [columns.0.z, columns.1.z, columns.2.z]
        
        return matrix_float3x3(rows: (r1, r2, r3))
    }
}

// MARK: - Multiplication

public func *(lhs: matrix_float2x2, rhs: matrix_float2x2) -> matrix_float2x2 {
    return matrix_multiply(lhs, rhs)
}

public func *(lhs: matrix_float3x3, rhs: matrix_float3x3) -> matrix_float3x3 {
    return matrix_multiply(lhs, rhs)
}

public func *(lhs: matrix_float4x4, rhs: matrix_float4x4) -> matrix_float4x4 {
    return matrix_multiply(lhs, rhs)
}