#version 120

uniform sampler2D texture;
uniform vec3 sunPosition;
uniform float frameTimeCounter;

varying vec2 texcoord;
varying vec4 color;

void main() {
    vec4 cloud = texture2D(texture, texcoord) * color;
    
    // Bulutlarni yumshatish
    cloud.rgb = mix(cloud.rgb, 
        vec3(1.0, 1.0, 1.0), 0.15);
    
    // Quyosh tomondagi bulutlar yorqinroq
    vec3 sunDir = normalize(sunPosition);
    float sunInfluence = max(sunDir.y, 0.0);
    vec3 sunColor = vec3(1.0, 0.85, 0.6);
    cloud.rgb = mix(cloud.rgb, 
        sunColor, sunInfluence * 0.3);
    
    // Chekkalarni yumshatish
    float alpha = cloud.a;
    alpha = smoothstep(0.0, 0.4, alpha);
    cloud.a = alpha;
    
    gl_FragData[0] = cloud;
}
