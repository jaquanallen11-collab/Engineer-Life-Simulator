#include <metal_stdlib>
using namespace metal;

struct VertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
};

vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                              constant float &time [[buffer(0)]],
                              constant float *particles [[buffer(1)]]) {
    VertexOut out;
    
    uint particleIndex = vertexID * 4;
    float x = particles[particleIndex];
    float y = particles[particleIndex + 1];
    float size = particles[particleIndex + 2];
    float hue = particles[particleIndex + 3];
    
    // Animate particles with sine wave motion
    float animX = x + sin(time * 0.5 + y * 3.14) * 0.1;
    float animY = y + cos(time * 0.3 + x * 3.14) * 0.1;
    
    out.position = float4(animX, animY, 0, 1);
    out.pointSize = size * 50.0;
    
    // Create color from hue with time-based variation
    float r = sin(hue * 6.28 + time) * 0.5 + 0.5;
    float g = sin(hue * 6.28 + time + 2.09) * 0.5 + 0.5;
    float b = sin(hue * 6.28 + time + 4.18) * 0.5 + 0.5;
    
    out.color = float4(r, g, b, 0.6);
    
    return out;
}

fragment float4 fragmentShader(VertexOut in [[stage_in]],
                               float2 pointCoord [[point_coord]]) {
    // Create circular particles
    float dist = distance(pointCoord, float2(0.5));
    if (dist > 0.5) {
        discard_fragment();
    }
    
    float alpha = in.color.a * (1.0 - dist * 2.0);
    return float4(in.color.rgb, alpha);
}
// MARK: - Dynamic Visual System Rendering Shaders

struct DynamicParticle {
    float2 position;
    float2 velocity;
    float2 acceleration;
    float4 color;
    float size;
    float energy;
    float lifetime;
    float maxLifetime;
};

struct VisualRenderParams {
    float time;
    float intensity;
    float energyLevel;
    float3 moodColor;
    uint particleCount;
};

struct DynamicVertexOut {
    float4 position [[position]];
    float pointSize [[point_size]];
    float4 color;
    float energy;
    float2 particlePos;
};

vertex DynamicVertexOut dynamicVisualVertex(
    uint vertexID [[vertex_id]],
    device DynamicParticle *particles [[buffer(0)]],
    constant VisualRenderParams &params [[buffer(1)]]
) {
    DynamicVertexOut out;
    
    if (vertexID >= params.particleCount) {
        out.position = float4(0);
        out.pointSize = 0;
        return out;
    }
    
    DynamicParticle particle = particles[vertexID];
    
    // Position
    out.position = float4(particle.position, 0, 1);
    out.particlePos = particle.position;
    
    // Size with energy-based scaling
    float energyScale = 1.0 + particle.energy * 0.5;
    out.pointSize = particle.size * 300.0 * params.intensity * energyScale;
    
    // Color with enhanced glow
    float lifetimeRatio = particle.lifetime / particle.maxLifetime;
    float fade = 1.0 - lifetimeRatio * lifetimeRatio;
    
    out.color = particle.color;
    out.color.a *= fade;
    out.energy = particle.energy;
    
    return out;
}

fragment float4 dynamicVisualFragment(
    DynamicVertexOut in [[stage_in]],
    float2 pointCoord [[point_coord]],
    constant VisualRenderParams &params [[buffer(0)]]
) {
    // Create soft circular particles with glow
    float2 center = float2(0.5);
    float dist = distance(pointCoord, center);
    
    if (dist > 0.5) {
        discard_fragment();
    }
    
    // Core of the particle
    float core = 1.0 - smoothstep(0.0, 0.2, dist);
    
    // Glow falloff
    float glow = 1.0 - smoothstep(0.2, 0.5, dist);
    
    // Combine core and glow
    float intensity = core + glow * 0.6;
    
    // Add energy-based pulsing
    float pulse = sin(params.time * 3.0 + in.energy * 10.0) * 0.2 + 0.8;
    intensity *= pulse;
    
    // Color with added brightness
    float4 color = in.color;
    color.rgb *= (1.0 + in.energy * 0.5);
    color.a *= intensity;
    
    // Add subtle chromatic aberration effect
    float2 offset = (pointCoord - center) * 0.02;
    color.r *= 1.0 + offset.x;
    color.b *= 1.0 - offset.x;
    
    return color;
}

// Background field rendering shader
struct FieldVertexOut {
    float4 position [[position]];
    float2 uv;
};

vertex FieldVertexOut fieldBackgroundVertex(uint vertexID [[vertex_id]]) {
    FieldVertexOut out;
    
    // Full-screen quad
    float2 positions[6] = {
        float2(-1, -1), float2(1, -1), float2(-1, 1),
        float2(-1, 1), float2(1, -1), float2(1, 1)
    };
    
    out.position = float4(positions[vertexID], 0, 1);
    out.uv = positions[vertexID] * 0.5 + 0.5;
    
    return out;
}

fragment float4 fieldBackgroundFragment(
    FieldVertexOut in [[stage_in]],
    device float *energyField [[buffer(0)]],
    constant VisualRenderParams &params [[buffer(1)]]
) {
    float2 uv = in.uv;
    
    // Convert UV to grid coordinates
    uint gridSize = 128; // Should match the grid size in DynamicVisualSystem
    uint2 gridPos = uint2(uv * float(gridSize));
    gridPos = clamp(gridPos, uint2(0), uint2(gridSize - 1));
    uint index = gridPos.y * gridSize + gridPos.x;
    
    float field = energyField[index];
    
    // Create visual representation of the field
    float3 color = params.moodColor;
    
    // Intensity based on field strength
    float intensity = abs(field) * params.intensity;
    color *= intensity;
    
    // Add some gradient
    float gradient = 1.0 - length(uv * 2.0 - 1.0) * 0.5;
    color *= gradient;
    
    return float4(color, intensity * 0.3);
}