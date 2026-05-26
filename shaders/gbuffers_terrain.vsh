#version 120

attribute vec4 mc_Entity;

uniform mat4 gbufferModelView;
uniform mat4 gbufferProjection;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying float isMetallic;

void main() {
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    color = gl_Color;
    normal = normalize(gl_NormalMatrix * gl_Normal);
    
    // Metal bloklarni aniqlash
    // iron_block=42, gold_block=41, diamond_block=57
    float blockId = mc_Entity.x;
    isMetallic = 0.0;
    if (blockId == 42.0 || 
        blockId == 41.0 || 
        blockId == 57.0 ||
        blockId == 265.0) {
        isMetallic = 1.0;
    }
    
    gl_Position = ftransform();
}
