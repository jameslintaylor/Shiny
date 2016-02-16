//
//  Rotation.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import simd

public func rotationMatrix(axis axis: vector_float3, angle: Float) -> matrix_float3x3 {
    let c = cos(angle)
    let s = sin(angle)
    let t = 1 - c
    let x = axis.x
    let y = axis.y
    let z = axis.z
    
    let r1: vector_float3 = [t*x*x + c, t*x*y - z*s, t*x*z + y*s]
    let r2: vector_float3 = [t*x*y + z*s, t*y*y + c, t*y*z - x*s]
    let r3: vector_float3 = [t*x*z - y*s, t*y*z + x*s, t*z*z + c]
    
    return matrix_float3x3(rows: (r1, r2, r3))
}

public func rotationMatrix(axis axis: vector_float3, angle: Float) -> matrix_float4x4 {
    let m: matrix_float3x3 = rotationMatrix(axis: axis, angle: angle)
    
    let r1: vector_float4 = [m.columns.0.x, m.columns.1.x, m.columns.2.x, 0]
    let r2: vector_float4 = [m.columns.0.y, m.columns.1.y, m.columns.2.y, 0]
    let r3: vector_float4 = [m.columns.0.z, m.columns.1.z, m.columns.2.z, 0]
    let r4: vector_float4 = [0, 0, 0, 1]
    
    return matrix_float4x4(rows: (r1, r2, r3, r4))
}