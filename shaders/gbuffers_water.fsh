#version 120

uniform sampler2D texture;
uniform sampler2D noisetex;

uniform vec3 sunPosition;
uniform float frameTimeCounter;
uniform mat4 gbufferModelView;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;

vec3 getSunDir() {
    return normalize((gbufferModelView * 
        vec4(sunPosition, 0.0)).xyz);
}

// Suv to'lqin effekti
vec2 waveOffset(vec2 uv, float time) {
    float wave1 = sin(uv.x * 3.0 + time) * 0.02;
    float wave2 = cos(uv.y * 2.5 + time * 0.8) * 0.02;
    return vec2(wave1, wave2);
}

void main() {
    float time = frameTimeCounter;
    
    // To'lqin
    vec2 waveUV = texcoord + waveOffset(texcoord, time);
    vec4 albedo = texture2D(texture, waveUV) * color;
    
    // Ozgina ko'k rang
    albedo.rgb = mix(albedo.rgb, 
        vec3(0.1, 0.3, 0.6), 0.2);
    
    // Quyosh aks
    vec3 sunDir = getSunDir();
    vec3 viewDir = vec3(0.0, 0.0, 1.0);
    vec3 halfVec = normalize(sunDir + viewDir);
    float spec = pow(max(dot(normalize(normal), 
        halfVec), 0.0), 32.0) * 0.3;
    
    albedo.rgb += vec3(1.0, 0.95, 0.8) * spec;
    albedo.a = 0.7;
    
    gl_FragData[0] = albedo;
}
