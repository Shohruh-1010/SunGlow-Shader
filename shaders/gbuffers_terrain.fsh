#version 120

uniform sampler2D texture;
uniform sampler2D specular;

uniform vec3 sunPosition;
uniform mat4 gbufferModelView;

varying vec2 texcoord;
varying vec4 color;
varying vec3 normal;
varying float isMetallic;

vec3 getSunDir() {
    return normalize((gbufferModelView * vec4(sunPosition, 0.0)).xyz);
}

// Metal aks ettirish
float metalReflection(vec3 normal, vec3 sunDir) {
    vec3 viewDir = normalize(vec3(0.0, 0.0, 1.0));
    vec3 halfVec = normalize(sunDir + viewDir);
    float spec = pow(max(dot(normal, halfVec), 0.0), 64.0);
    return spec * isMetallic;
}

void main() {
    vec4 albedo = texture2D(texture, texcoord) * color;
    
    vec3 sunDir = getSunDir();
    
    // Metal bloklarda aks ettirish
    float reflection = metalReflection(
        normalize(normal), sunDir
    );
    
    // Quyosh rangi bilan aks
    vec3 sunColor = vec3(1.0, 0.95, 0.8);
    albedo.rgb += sunColor * reflection * 0.8;
    
    gl_FragData[0] = albedo;
}
