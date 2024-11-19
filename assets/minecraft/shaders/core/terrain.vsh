#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:darkness.glsl>

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
out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;


uniform float FogEnd;
uniform vec2 ScreenSize;
uniform float GameTime;

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
    vec4 light = get_vertex_light(Sampler2, gl_Position, UV2, ScreenSize, FogEnd, GameTime);

    vertexColor = Color * vec4(light.rgb,light.a);
    texCoord0 = UV0;
}
