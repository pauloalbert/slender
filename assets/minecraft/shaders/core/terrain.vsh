#version 330

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


uniform float FogEnd;
out float has_blindness;
out float has_night_vision;


bool isBlind(float FogEnd) {return (isinf(FogEnd) || isnan(FogEnd) || FogEnd < 10.0);}

bool isNightVisioned(sampler2D lightMap) {
    vec4 dark_value = minecraft_sample_lightmap(Sampler2, ivec2(0,0));
    vec4 light_value = minecraft_sample_lightmap(Sampler2, ivec2(255,255));
    //length is greater than 1.25 without night_vision.
    //if a variable solution is needed (for nthe flickjering for example, use return 1.25-length(...) (with smoothstep))
    return length(dark_value - light_value) < 0.5;
}


void main() {
    // Object transformationse
    vec3 pos = Position + ModelOffset;
    gl_Position = ProjMat * ModelViewMat * vec4(pos, 1.0);

    vertexDistance = fog_distance(pos, FogShape);

    // Light from lightmap
    vec4 light = minecraft_sample_lightmap(Sampler2, UV2);

    has_blindness = isBlind(FogEnd) ? 1 : 0;
    has_night_vision = isNightVisioned(Sampler2) ? 1 : 0;

    if(has_blindness < 0.001) {
        // Circle - changing the lighting if in the circle
        float aspect = ScreenSize.x / ScreenSize.y;
        vec2 center = gl_Position.xy - vec2(0.5,0.5);
        center.x *= aspect;
        float radius = 0.7;
        if (dot(center,center)  < radius * gl_Position.z* gl_Position.z) {
            float value = 1 - (dot(center,center) / (gl_Position.z*gl_Position.z)) / radius;
            value *= 0.9;
            value = min(0.6,value);
            value *= (1-1/gl_Position.z);
            light = vec4(vec3(max(value,light.x)), 1.0);
        }
    }
    vertexColor = Color * vec4(light.rgb,light.a);
    texCoord0 = UV0;
}
