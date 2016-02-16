//
//  Translation.swift
//  Shiny
//
//  Created by James Taylor on 2016-02-15.
//  Copyright © 2016 James Taylor. All rights reserved.
//

import simd

public func translationMatrix(translation translation: vector_float3) -> matrix_float4x4 {
    
    let r1: vector_float4 = [1, 0, 0, translation.x]
    let r2: vector_float4 = [0, 1, 0, translation.y]
    let r3: vector_float4 = [0, 0, 1, translation.z]
    let r4: vector_float4 = [0, 0, 0, 1]
    
    return matrix_float4x4(rows: (r1, r2, r3, r4))
}
