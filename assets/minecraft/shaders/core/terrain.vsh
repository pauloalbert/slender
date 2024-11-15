#version 150

#moj_import <minecraft:light.glsl>
#moj_import <minecraft:fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform vec3 ModelOffset;
uniform int FogShape;
uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vertexDistance = fog_distance(pos, FogShape);
    vec4 light = minecraft_sample_lightmap(Sampler2, UV2);
    
    float aspect = ScreenSize.x / ScreenSize.y;
    vec2 center = gl_Position.xy - vec2(0.5,0.5);
    center.x *= aspect;
    float radius = 0;
    if (dot(center,center)  < radius * gl_Position.z) {
        float value = 1 - (dot(center,center) / gl_Position.z) / radius;
        value *= 0.9;
        value = min(0.6,value);
        light = vec4(vec3(max(value,light.x)), 1.0);
    }
    vertexColor = Color * vec4(light.rgb,light.a);
    texCoord0 = UV0;
}
