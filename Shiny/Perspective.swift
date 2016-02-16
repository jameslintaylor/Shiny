//
//  Perspective.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import simd

public func perspectiveMatrix(aspect aspect: Float, fovy: Float, near: Float, far: Float) -> matrix_float4x4 {
    let yScale = 1 / tan(fovy * 0.5)
    let xScale = yScale / aspect
    let zRange = far - near
    let zScale = -(far + near) / zRange
    let wzScale = -2 * far * near / zRange
    
    let r1: vector_float4 = [xScale, 0, 0, 0]
    let r2: vector_float4 = [0, yScale, 0, 0]
    let r3: vector_float4 = [0, 0, zScale, wzScale]
    let r4: vector_float4 = [0, 0, -1, 0]
    
    return matrix_float4x4(rows: (r1, r2, r3, r4))
}
