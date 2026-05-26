#version 120

uniform sampler2D texture;
uniform vec3 sunPosition;
uniform mat4 gbufferModelView;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying float isMetallic;

vec3 getSunDir() {
    return normalize((gbufferModelView * 
        vec4(sunPosition, 0.0)).xyz);
}

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    
    vec3 sunDir = getSunDir();
    vec3 halfVec = normalize(sunDir + 
        vec3(0.0, 0.0, 1.0));
    float spec = pow(max(dot(normalize(normal), 
        halfVec), 0.0), 64.0) * isMetallic * 0.6;
    
    vec3 sunColor = vec3(1.0, 0.95, 0.8);
    albedo.rgb += sunColor * spec;
    
    gl_FragData[0] = albedo;
}
