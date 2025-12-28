#include <metal_stdlib>
using namespace metal;

// MARK: - Enhanced Asset Rendering Shaders

struct VertexIn {
    float3 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float4 color [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
    float3 worldPosition;
    float3 normal;
    float4 color;
};

struct AssetUniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float3 lightPosition;
    float3 cameraPosition;
};

// MARK: - Vehicle Rendering with PBR

vertex VertexOut vehicleVertexShader(VertexIn in [[stage_in]],
                                     constant AssetUniforms &uniforms [[buffer(1)]]) {
    VertexOut out;
    
    float4 worldPos = uniforms.modelMatrix * float4(in.position, 1.0);
    out.worldPosition = worldPos.xyz;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * worldPos;
    out.normal = (uniforms.modelMatrix * float4(in.normal, 0.0)).xyz;
    out.color = in.color;
    
    return out;
}

fragment float4 vehicleFragmentShader(VertexOut in [[stage_in]],
                                      constant AssetUniforms &uniforms [[buffer(0)]]) {
    // PBR-style lighting
    float3 N = normalize(in.normal);
    float3 L = normalize(uniforms.lightPosition - in.worldPosition);
    float3 V = normalize(uniforms.cameraPosition - in.worldPosition);
    float3 H = normalize(L + V);
    
    // Diffuse
    float diffuse = max(dot(N, L), 0.0);
    
    // Specular (car paint effect)
    float metallic = 0.8;
    float roughness = 0.3;
    float spec = pow(max(dot(N, H), 0.0), 32.0 / (roughness * roughness));
    float3 specular = float3(spec) * metallic;
    
    // Ambient
    float3 ambient = float3(0.1);
    
    // Combine
    float3 finalColor = in.color.rgb * (ambient + diffuse * 0.7) + specular * 0.5;
    
    // Add metallic shine
    float fresnel = pow(1.0 - max(dot(V, N), 0.0), 3.0);
    finalColor += fresnel * 0.3 * metallic;
    
    return float4(finalColor, in.color.a);
}

// MARK: - Property Rendering with Architectural Details

vertex VertexOut propertyVertexShader(VertexIn in [[stage_in]],
                                      constant AssetUniforms &uniforms [[buffer(1)]]) {
    VertexOut out;
    
    float4 worldPos = uniforms.modelMatrix * float4(in.position, 1.0);
    out.worldPosition = worldPos.xyz;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * worldPos;
    out.normal = (uniforms.modelMatrix * float4(in.normal, 0.0)).xyz;
    out.color = in.color;
    
    return out;
}

fragment float4 propertyFragmentShader(VertexOut in [[stage_in]],
                                       constant AssetUniforms &uniforms [[buffer(0)]]) {
    float3 N = normalize(in.normal);
    float3 L = normalize(uniforms.lightPosition - in.worldPosition);
    
    // Building materials - matte finish
    float diffuse = max(dot(N, L), 0.0);
    float3 ambient = float3(0.15);
    
    // Add subtle window reflections
    float3 V = normalize(uniforms.cameraPosition - in.worldPosition);
    float reflection = pow(max(dot(V, N), 0.0), 4.0) * 0.2;
    
    // Combine
    float3 finalColor = in.color.rgb * (ambient + diffuse * 0.8) + reflection;
    
    return float4(finalColor, in.color.a);
}

// MARK: - Investment Data Visualization (Compute Shader)

struct InvestmentParams {
    float currentValue;
    float purchasePrice;
    float volatility;
    float time;
};

kernel void investmentVisualizer(texture2d<float, access::write> outTexture [[texture(0)]],
                                 constant InvestmentParams &params [[buffer(0)]],
                                 uint2 gid [[thread_position_in_grid]]) {
    
    uint width = outTexture.get_width();
    uint height = outTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float2 uv = float2(gid) / float2(width, height);
    
    // Calculate performance
    float performance = (params.currentValue - params.purchasePrice) / params.purchasePrice;
    
    // Create wave pattern based on volatility
    float wave = sin(uv.x * 10.0 + params.time) * params.volatility * 0.2;
    float line = abs(uv.y - 0.5 - performance - wave);
    
    // Color based on performance
    float3 color;
    if (performance > 0) {
        color = float3(0.2, 0.8, 0.3); // Green for profit
    } else {
        color = float3(0.9, 0.3, 0.2); // Red for loss
    }
    
    // Draw line
    float lineWidth = 0.02 / (1.0 + params.volatility);
    float alpha = smoothstep(lineWidth, 0.0, line);
    
    // Background gradient
    float3 bgColor = mix(float3(0.1, 0.1, 0.15), float3(0.15, 0.15, 0.2), uv.y);
    
    // Combine
    float3 finalColor = mix(bgColor, color, alpha);
    
    // Add grid
    float grid = max(
        smoothstep(0.98, 1.0, fract(uv.x * 10.0)),
        smoothstep(0.98, 1.0, fract(uv.y * 10.0))
    );
    finalColor += grid * 0.1;
    
    outTexture.write(float4(finalColor, 1.0), gid);
}

// MARK: - Asset Particle Effects

struct Particle {
    float3 position;
    float3 velocity;
    float4 color;
    float life;
};

kernel void assetParticleEffect(device Particle *particles [[buffer(0)]],
                                constant float &time [[buffer(1)]],
                                uint id [[thread_position_in_grid]]) {
    
    Particle p = particles[id];
    
    if (p.life > 0) {
        // Update position
        p.position += p.velocity * 0.016;
        
        // Apply gravity
        p.velocity.y -= 0.5 * 0.016;
        
        // Fade out
        p.life -= 0.016;
        p.color.a = p.life;
        
        particles[id] = p;
    }
}

// MARK: - Luxury Glow Effect

kernel void luxuryGlowEffect(texture2d<float, access::read> inTexture [[texture(0)]],
                             texture2d<float, access::write> outTexture [[texture(1)]],
                             constant float &intensity [[buffer(0)]],
                             uint2 gid [[thread_position_in_grid]]) {
    
    uint width = inTexture.get_width();
    uint height = inTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float4 color = inTexture.read(gid);
    
    // Calculate brightness
    float brightness = dot(color.rgb, float3(0.299, 0.587, 0.114));
    
    // Add golden glow to bright areas
    if (brightness > 0.7) {
        float glow = (brightness - 0.7) * intensity;
        color.rgb += float3(1.0, 0.8, 0.3) * glow;
    }
    
    outTexture.write(color, gid);
}

// MARK: - Player Avatar Shaders

struct AvatarUniforms {
    float4x4 modelMatrix;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float4 skinToneColor;
    float4 hairColor;
    float4 eyeColor;
    float3 lightPosition;
};

vertex VertexOut avatarVertexShader(VertexIn in [[stage_in]],
                                    constant AvatarUniforms &uniforms [[buffer(1)]]) {
    VertexOut out;
    
    float4 worldPos = uniforms.modelMatrix * float4(in.position, 1.0);
    out.worldPosition = worldPos.xyz;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * worldPos;
    out.normal = (uniforms.modelMatrix * float4(in.normal, 0.0)).xyz;
    out.color = in.color;
    
    return out;
}

fragment float4 avatarFragmentShader(VertexOut in [[stage_in]],
                                     constant AvatarUniforms &uniforms [[buffer(0)]]) {
    float3 N = normalize(in.normal);
    float3 L = normalize(uniforms.lightPosition - in.worldPosition);
    
    // Subsurface scattering approximation for skin
    float dotNL = dot(N, L);
    float diffuse = max(dotNL, 0.0);
    float subsurface = max(0.0, -dotNL) * 0.3; // Back scattering
    
    float3 ambient = float3(0.2);
    
    // Determine color based on body part (simplified)
    float4 baseColor;
    if (in.worldPosition.y > 1.0) {
        // Head - use skin tone
        baseColor = uniforms.skinToneColor;
    } else if (in.worldPosition.y > 0.5) {
        // Upper body - clothing would go here
        baseColor = float4(0.3, 0.4, 0.6, 1.0);
    } else {
        // Lower body
        baseColor = float4(0.2, 0.2, 0.3, 1.0);
    }
    
    float3 finalColor = baseColor.rgb * (ambient + diffuse * 0.8 + subsurface);
    
    return float4(finalColor, 1.0);
}

// MARK: - Realistic Skin Shader (Compute)

kernel void realisticSkinShader(texture2d<float, access::read> inTexture [[texture(0)]],
                                texture2d<float, access::write> outTexture [[texture(1)]],
                                constant float4 &skinTone [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]]) {
    
    uint width = inTexture.get_width();
    uint height = inTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float4 color = inTexture.read(gid);
    
    // Apply skin tone
    color.rgb *= skinTone.rgb;
    
    // Add subtle skin texture
    float2 uv = float2(gid) / float2(width, height);
    float noise = fract(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
    color.rgb += (noise - 0.5) * 0.02;
    
    // Add slight red undertone for realism
    color.r += 0.05;
    
    outTexture.write(color, gid);
}

// MARK: - Holographic UI Effects

kernel void holographicUIEffect(texture2d<float, access::write> outTexture [[texture(0)]],
                                constant float &time [[buffer(0)]],
                                uint2 gid [[thread_position_in_grid]]) {
    
    uint width = outTexture.get_width();
    uint height = outTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float2 uv = float2(gid) / float2(width, height);
    
    // Animated scan lines
    float scanLine = sin((uv.y + time * 0.5) * 50.0) * 0.05;
    
    // Holographic color shift
    float3 color = float3(
        0.3 + sin(time + uv.x * 3.0) * 0.2,
        0.5 + cos(time * 1.5 + uv.y * 2.0) * 0.3,
        0.8 + sin(time * 2.0) * 0.2
    );
    
    color += scanLine;
    
    // Add transparency for overlay effect
    float alpha = 0.3 + sin(time) * 0.1;
    
    outTexture.write(float4(color, alpha), gid);
}

// MARK: - Asset Preview Rotation Animation

kernel void rotatingAssetEffect(texture2d<float, access::write> outTexture [[texture(0)]],
                                constant float &rotation [[buffer(0)]],
                                constant float3 &objectColor [[buffer(1)]],
                                uint2 gid [[thread_position_in_grid]]) {
    
    uint width = outTexture.get_width();
    uint height = outTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float2 uv = (float2(gid) / float2(width, height)) * 2.0 - 1.0;
    
    // Simple 2D projection of rotating 3D object
    float cosR = cos(rotation);
    float sinR = sin(rotation);
    
    float2 rotated = float2(
        uv.x * cosR - uv.y * sinR,
        uv.x * sinR + uv.y * cosR
    );
    
    // Simple shape rendering
    float dist = length(rotated);
    float shape = smoothstep(0.5, 0.48, dist);
    
    float3 color = objectColor * shape;
    
    // Add rim lighting
    float rim = smoothstep(0.5, 0.45, dist) - smoothstep(0.48, 0.43, dist);
    color += rim * 0.5;
    
    outTexture.write(float4(color, shape), gid);
}

// MARK: - ML Prediction Kernel

kernel void careerPredictionKernel(
    constant float *inputData [[buffer(0)]],
    device float *outputData [[buffer(1)]],
    uint id [[thread_position_in_grid]]
) {
    // Simple career prediction simulation
    // In production, this would be replaced by CoreML-generated Metal code
    
    if (id < 4) {
        float input = inputData[id];
        
        // Simulate neural network inference
        float weight = 0.8 + float(id) * 0.05;
        float bias = 0.1;
        float activation = tanh(input * weight + bias);
        
        // Normalize to [0, 1]
        outputData[id] = (activation + 1.0) * 0.5;
    }
}

// MARK: - Advanced Particle Rendering

struct ParticleData {
    float2 position;
    float2 velocity;
    float4 color;
    float size;
    float lifetime;
};

kernel void updateParticles(
    device ParticleData *particles [[buffer(0)]],
    constant float &deltaTime [[buffer(1)]],
    constant float &time [[buffer(2)]],
    uint id [[thread_position_in_grid]],
    uint particleCount [[threads_per_grid]]
) {
    if (id >= particleCount) return;
    
    ParticleData particle = particles[id];
    
    // Physics simulation
    float2 gravity = float2(0.0, -0.1);
    particle.velocity += gravity * deltaTime;
    particle.position += particle.velocity * deltaTime;
    
    // Color animation
    float hue = fract(time * 0.1 + particle.position.x * 0.5);
    particle.color.r = sin(hue * 6.28) * 0.5 + 0.5;
    particle.color.g = sin(hue * 6.28 + 2.09) * 0.5 + 0.5;
    particle.color.b = sin(hue * 6.28 + 4.18) * 0.5 + 0.5;
    
    // Update lifetime
    particle.lifetime -= deltaTime;
    
    // Respawn if dead
    if (particle.lifetime <= 0.0) {
        particle.position = float2(
            fract(sin(float(id) * 43758.5453)) * 2.0 - 1.0,
            -1.2
        );
        particle.velocity = float2(
            (fract(sin(float(id) * 12.9898)) - 0.5) * 0.1,
            fract(sin(float(id) * 78.233)) * 0.3
        );
        particle.lifetime = 10.0;
    }
    
    particles[id] = particle;
}

// MARK: - Post-Processing Effects

kernel void bloomEffect(
    texture2d<float, access::read> inputTexture [[texture(0)]],
    texture2d<float, access::write> outputTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }
    
    float4 color = inputTexture.read(gid);
    
    // Extract bright areas
    float brightness = dot(color.rgb, float3(0.2126, 0.7152, 0.0722));
    float threshold = 0.7;
    
    if (brightness > threshold) {
        color *= (brightness - threshold) / (1.0 - threshold);
    } else {
        color = float4(0.0);
    }
    
    outputTexture.write(color, gid);
}

// MARK: - Dynamic Visual System Shaders

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

struct WaveParams {
    float time;
    float deltaTime;
    float intensity;
    float energyLevel;
    uint gridSize;
};

struct FieldParams {
    float time;
    float energyLevel;
    float3 moodColor;
    uint gridSize;
};

struct ParticleParams {
    float time;
    float deltaTime;
    float energyLevel;
    float3 moodColor;
    uint particleCount;
    uint gridSize;
};

// Wave simulation kernel
kernel void waveSimulation(
    device float4 *waveGrid [[buffer(0)]],
    constant WaveParams &params [[buffer(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= params.gridSize || gid.y >= params.gridSize) return;
    
    uint index = gid.y * params.gridSize + gid.x;
    float4 wave = waveGrid[index];
    
    // Wave components: xy = velocity, z = height, w = energy
    float2 velocity = wave.xy;
    float height = wave.z;
    float energy = wave.w;
    
    // Calculate neighbors for wave propagation
    float neighborHeight = 0.0;
    int neighbors = 0;
    
    for (int dy = -1; dy <= 1; dy++) {
        for (int dx = -1; dx <= 1; dx++) {
            if (dx == 0 && dy == 0) continue;
            
            int nx = int(gid.x) + dx;
            int ny = int(gid.y) + dy;
            
            if (nx >= 0 && nx < int(params.gridSize) && ny >= 0 && ny < int(params.gridSize)) {
                uint nIndex = ny * params.gridSize + nx;
                neighborHeight += waveGrid[nIndex].z;
                neighbors++;
            }
        }
    }
    
    neighborHeight /= float(neighbors);
    
    // Wave equation
    float acceleration = (neighborHeight - height) * 0.5;
    velocity.x = velocity.x * 0.99 + acceleration * params.deltaTime * params.intensity;
    height += velocity.x * params.deltaTime;
    
    // Add some noise based on energy
    float2 noisePos = float2(gid) / float(params.gridSize) + params.time * 0.1;
    float noise = sin(noisePos.x * 10.0 + params.time) * cos(noisePos.y * 10.0 + params.time);
    height += noise * 0.001 * params.energyLevel * params.intensity;
    
    // Update energy based on wave activity
    energy = mix(energy, abs(velocity.x) * 10.0, 0.1);
    
    // Store back
    waveGrid[index] = float4(velocity.x, velocity.y, height, energy);
}

// Energy field effect kernel
kernel void energyFieldEffect(
    device float *energyField [[buffer(0)]],
    device float4 *waveGrid [[buffer(1)]],
    constant FieldParams &params [[buffer(2)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= params.gridSize || gid.y >= params.gridSize) return;
    
    uint index = gid.y * params.gridSize + gid.x;
    
    // Get wave data
    float4 wave = waveGrid[index];
    float waveHeight = wave.z;
    float waveEnergy = wave.w;
    
    // Calculate field position
    float2 pos = float2(gid) / float(params.gridSize) * 2.0 - 1.0;
    float dist = length(pos);
    
    // Create energy field patterns
    float angle = atan2(pos.y, pos.x);
    float spiral = sin(angle * 5.0 + params.time * 2.0 + dist * 10.0);
    float rings = sin(dist * 20.0 - params.time * 3.0);
    
    // Combine patterns
    float field = (spiral + rings) * 0.5;
    field = mix(field, waveHeight * 10.0, 0.3);
    field *= params.energyLevel;
    
    // Add turbulence
    float turbulence = sin(pos.x * 8.0 + params.time) * cos(pos.y * 8.0 + params.time * 1.2);
    field += turbulence * 0.2 * params.energyLevel;
    
    energyField[index] = field;
}

// Advanced particle physics kernel
kernel void advancedParticlePhysics(
    device DynamicParticle *particles [[buffer(0)]],
    device float *energyField [[buffer(1)]],
    constant ParticleParams &params [[buffer(2)]],
    uint id [[thread_position_in_grid]]
) {
    if (id >= params.particleCount) return;
    
    DynamicParticle particle = particles[id];
    
    // Sample energy field
    float2 fieldPos = (particle.position + 1.0) * 0.5;
    uint2 gridPos = uint2(fieldPos * float(params.gridSize));
    gridPos = clamp(gridPos, uint2(0), uint2(params.gridSize - 1));
    uint fieldIndex = gridPos.y * params.gridSize + gridPos.x;
    float fieldStrength = energyField[fieldIndex];
    
    // Apply energy field force
    float2 toCenter = -particle.position;
    float distToCenter = length(toCenter);
    float2 centerForce = normalize(toCenter) * (distToCenter * 0.1);
    
    // Swirl force
    float angle = atan2(particle.position.y, particle.position.x);
    float2 swirlForce = float2(-sin(angle), cos(angle)) * params.energyLevel * 0.05;
    
    // Field-based force
    float2 fieldGradient = float2(
        sin(particle.position.x * 10.0 + params.time),
        cos(particle.position.y * 10.0 + params.time)
    ) * fieldStrength * 0.02;
    
    // Combine forces
    particle.acceleration = centerForce + swirlForce + fieldGradient;
    
    // Update velocity and position
    particle.velocity += particle.acceleration * params.deltaTime;
    particle.velocity *= 0.98; // Damping
    particle.position += particle.velocity * params.deltaTime;
    
    // Keep particles in bounds with soft boundary
    float boundaryDist = 1.2;
    if (length(particle.position) > boundaryDist) {
        particle.position = normalize(particle.position) * boundaryDist;
        particle.velocity *= -0.5;
    }
    
    // Update color based on energy and mood
    particle.energy = mix(particle.energy, abs(fieldStrength), 0.1);
    float3 energyColor = params.moodColor * (0.5 + particle.energy * 0.5);
    float3 speedColor = float3(1.0, 0.5, 0.2) * length(particle.velocity) * 10.0;
    particle.color.rgb = mix(energyColor, speedColor, 0.3);
    
    // Update lifetime
    particle.lifetime += params.deltaTime;
    if (particle.lifetime > particle.maxLifetime) {
        particle.lifetime = 0.0;
        // Respawn particle
        float respawnAngle = float(id) / float(params.particleCount) * 6.28318 + params.time;
        float respawnRadius = 0.8;
        particle.position = float2(cos(respawnAngle), sin(respawnAngle)) * respawnRadius;
        particle.velocity = float2(0.0);
    }
    
    // Fade based on lifetime
    float lifetimeRatio = particle.lifetime / particle.maxLifetime;
    particle.color.a = 1.0 - lifetimeRatio * lifetimeRatio;
    
    particles[id] = particle;
}

// Render dynamic particles to texture
kernel void renderDynamicParticles(
    texture2d<float, access::write> outputTexture [[texture(0)]],
    device DynamicParticle *particles [[buffer(0)]],
    constant uint &particleCount [[buffer(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    uint width = outputTexture.get_width();
    uint height = outputTexture.get_height();
    
    if (gid.x >= width || gid.y >= height) return;
    
    float2 uv = float2(gid) / float2(width, height) * 2.0 - 1.0;
    uv.y *= float(height) / float(width); // Aspect ratio correction
    
    float4 color = float4(0.0);
    
    // Render each particle as a soft circle
    for (uint i = 0; i < particleCount; i++) {
        DynamicParticle particle = particles[i];
        
        float2 toParticle = uv - particle.position;
        float dist = length(toParticle);
        
        if (dist < particle.size * 3.0) {
            float influence = exp(-dist * dist / (particle.size * particle.size));
            color += particle.color * influence * particle.energy;
        }
    }
    
    color = clamp(color, 0.0, 1.0);
    outputTexture.write(color, gid);
}

kernel void gaussianBlur(
    texture2d<float, access::read> inputTexture [[texture(0)]],
    texture2d<float, access::write> outputTexture [[texture(1)]],
    constant float &radius [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }
    
    float4 sum = float4(0.0);
    float weightSum = 0.0;
    
    int r = int(radius);
    for (int y = -r; y <= r; y++) {
        for (int x = -r; x <= r; x++) {
            int2 offset = int2(x, y);
            uint2 samplePos = uint2(int2(gid) + offset);
            
            float distance = length(float2(x, y));
            float weight = exp(-distance * distance / (2.0 * radius * radius));
            
            sum += inputTexture.read(samplePos) * weight;
            weightSum += weight;
        }
    }
    
    outputTexture.write(sum / weightSum, gid);
}

// MARK: - UI Effects

kernel void glassBlurEffect(
    texture2d<float, access::read> inputTexture [[texture(0)]],
    texture2d<float, access::write> outputTexture [[texture(1)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }
    
    float4 sum = float4(0.0);
    
    // Sample surrounding pixels for blur
    for (int y = -2; y <= 2; y++) {
        for (int x = -2; x <= 2; x++) {
            uint2 samplePos = uint2(int2(gid) + int2(x, y));
            sum += inputTexture.read(samplePos);
        }
    }
    
    float4 blurred = sum / 25.0;
    
    // Add glassmorphism effect
    blurred.rgb *= 1.1; // Slight brightness boost
    blurred.a = 0.7; // Transparency
    
    outputTexture.write(blurred, gid);
}

// MARK: - Neon Glow Effect

kernel void neonGlowEffect(
    texture2d<float, access::read> inputTexture [[texture(0)]],
    texture2d<float, access::write> outputTexture [[texture(1)]],
    constant float &time [[buffer(0)]],
    uint2 gid [[thread_position_in_grid]]
) {
    if (gid.x >= outputTexture.get_width() || gid.y >= outputTexture.get_height()) {
        return;
    }
    
    float4 color = inputTexture.read(gid);
    
    // Animated neon glow
    float pulse = sin(time * 2.0) * 0.2 + 0.8;
    color.rgb *= pulse;
    
    // Add outer glow
    float brightness = dot(color.rgb, float3(0.299, 0.587, 0.114));
    color.rgb += float3(0.1, 0.0, 0.3) * brightness * pulse;
    
    outputTexture.write(color, gid);
}
