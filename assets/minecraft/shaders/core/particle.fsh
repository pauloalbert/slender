#version 150

#moj_import <minecraft:fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;

out vec4 fragColor;

// ShaderSelector
flat in int isMarker;
flat in ivec4 iColor;

void main() {
    // ShaderSelector
    if (isMarker == 2) {
        discard;
    }
    if (isMarker == 1) {
        fragColor = vec4(iColor.rgb, 255) / 255.0;
        return;
    }
    // Vanilla code
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
