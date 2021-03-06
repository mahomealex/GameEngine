import Metal

private struct ShapeUniforms {
  let model: Mat4
  let color: Vec4
}

final class ShapePipeline: RenderPipeline {
  let pipelineState: MTLRenderPipelineState

  private var didSetBuffer = false
  private let instanceBuffer: Buffer

  private struct Programs {
    static let Shader = "ShapeShaders"
    static let Vertex = "colorVertex"
    static let Fragment = "colorFragment"
  }

  init(device: MTLDevice,
       vertexProgram: String = Programs.Vertex,
       fragmentProgram: String = Programs.Fragment) {
    
    let pipelineDescriptor = ShapePipeline.makePipelineDescriptor(device: device,
                                                                  vertexProgram: vertexProgram,
                                                                  fragmentProgram: fragmentProgram)
    self.pipelineState = ShapePipeline.createPipelineState(device, descriptor: pipelineDescriptor)!

    instanceBuffer = Buffer(device: device, length: 1000 * MemoryLayout<Mat4>.size)
  }
}

extension ShapePipeline {
  func encode(encoder: MTLRenderCommandEncoder,
              bufferIndex: Int,
              vertexBuffer: Buffer,
              indexBuffer: Buffer,
              uniformBuffer: Buffer,
              nodes: [ShapeNode],
              lights: [LightNode]? = nil) {
    guard let node = nodes.first else { return }

    encoder.setRenderPipelineState(pipelineState)

    if !didSetBuffer {
      didSetBuffer = true
      vertexBuffer.update(data: node.quad.vertices, size: node.quad.size, bufferIndex: bufferIndex)
    }
    let (vBuffer, offset) = vertexBuffer.next(index: bufferIndex)
    encoder.setVertexBuffer(vBuffer, offset: offset, index: 0)

    nodes.enumerated().forEach { (inode) in
      let (i, node) = inode
      instanceBuffer.update(data: [ShapeUniforms(model: node.model, color: node.color.vec4)],
                            size: MemoryLayout<ShapeUniforms>.size,
                            bufferIndex: bufferIndex,
                            offset: MemoryLayout<ShapeUniforms>.size * i)
    }
    let (inBuffer, inOffset) = instanceBuffer.next(index: bufferIndex)
    encoder.setVertexBuffer(inBuffer, offset: inOffset, index: 1)

    let (uBuffer, uOffset) = uniformBuffer.next(index: bufferIndex)
    encoder.setVertexBuffer(uBuffer, offset: uOffset, index: 2)

    let (iBuffer, iOffset) = indexBuffer.next(index: bufferIndex)
    encoder.drawIndexedPrimitives(type: .triangle,
                                  indexCount: 6,
                                  indexType: .uint16,
                                  indexBuffer: iBuffer,
                                  indexBufferOffset: iOffset,
                                  instanceCount: nodes.count)
  }
}
