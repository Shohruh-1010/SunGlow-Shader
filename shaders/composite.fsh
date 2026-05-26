#version 120

uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D noisetex;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;

uniform vec3 sunPosition;
uniform float frameTimeCounter;

varying vec2 texcoord;

// Quyosh nuri yo'nalishi
vec3 getSunDirection() {
    return normalize(sunPosition);
}

// Quyosh bloumi
vec3 sunBloom(vec3 color, vec2 uv) {
    vec3 sunDir = getSunDirection();
    float sunDot = max(dot(normalize(vec3(uv - 0.5, 1.0)), sunDir), 0.0);
    float bloom = pow(sunDot, 32.0) * 0.6;
    return color + vec3(1.0, 0.9, 0.7) * bloom;
}

void main() {
    vec4 color = texture2D(colortex0, texcoord);
    
    // Quyosh bloumi qo'shish
    color.rgb = sunBloom(color.rgb, texcoord);
    
    gl_FragData[0] = color;
}
